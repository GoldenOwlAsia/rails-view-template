class Rack::Attack
  # Throttle all requests by IP.
  throttle('req/ip', limit: 300, period: 5.minutes) do |req|
    req.ip unless req.path.start_with?('/assets', '/vite')
  end

  # Throttle login attempts by IP address.
  throttle('logins/ip', limit: 5, period: 20.seconds) do |req|
    req.ip if req.path == '/users/sign_in' && req.post?
  end

  # Throttle login attempts by email, regardless of IP.
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
