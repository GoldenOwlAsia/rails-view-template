Sentry.init do |config|
  config.dsn = ENV['SENTRY_DSN']
  config.traces_sample_rate = 1.0
  config.profiles_sample_rate = 1.0
  config.enabled_environments = ['staging', 'production']
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]
  config.traces_sampler = lambda do |context|
    true
  end
end
