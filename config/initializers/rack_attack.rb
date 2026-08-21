# Counters live in Rails.cache by default, which is :memory_store in every
# environment here. That makes every limit per-process: four Puma workers turn
# "5 logins per 20 seconds" into twenty, and a deploy resets the count. Redis is
# already in the stack for Sidekiq, so point the throttles at it instead.
Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new(
  url: ENV.fetch('REDIS_URL', 'redis://localhost:6379/0'),
  namespace: 'rack_attack'
)

class Rack::Attack
  # The load balancer polls this endpoint from a small set of IPs; without the
  # safelist a frequent poll eats into req/ip and the balancer reads the 429 as
  # a dead instance.
  safelist('health check') { |req| req.path == '/up' }

  # Throttle all requests by IP.
  throttle('req/ip', limit: 300, period: 5.minutes) do |req|
    req.ip unless req.path.start_with?('/assets', '/vite')
  end

  # Throttle login attempts by IP address.
  throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
    req.ip if req.path == '/users/sign_in' && req.post?
  end

  # Throttle login attempts by email, regardless of IP. The path and verb are
  # checked first on purpose: req.params parses the request body, and we only
  # want that for the small sign-in form.
  throttle('logins/email', limit: 5, period: 20.seconds) do |req|
    if req.path == '/users/sign_in' && req.post?
      req.params.dig('user', 'email').to_s.downcase.presence
    end
  end

  self.throttled_responder = lambda do |_request|
    [
      429,
      { 'Content-Type' => 'application/json' },
      [{ error: 'Too many requests. Please try again later.' }.to_json]
    ]
  end
end
