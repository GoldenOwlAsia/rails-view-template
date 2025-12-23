source 'https://rubygems.org'

ruby '3.4.7'

gem 'rails', '~> 8.1.1'

gem 'puma', '>= 5.0'
gem 'bootsnap', require: false
gem 'tzinfo-data', platforms: %i[windows jruby]

# Database
gem 'pg'
gem 'good_migrations'

# Auth
gem 'devise'
gem 'pundit'
gem 'rolify'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'

# File
gem 'ruby-vips'
gem 'image_processing', '~> 1.2'
gem 'active_storage_validations'

# Job
gem 'redis'
gem 'sidekiq'
gem 'sidekiq-scheduler'
gem 'sidekiq-unique-jobs'

# Front-end
gem 'slim-rails'
gem 'vite_rails'
gem 'turbo-rails'
gem 'stimulus-rails'

# Forms
gem 'simple_form'
gem 'simple_form-tailwind'

# Pagination
gem 'pagy'

# Tracking
gem 'stackprof'
gem 'sentry-ruby'
gem 'sentry-rails'

# Seed
gem 'faker'
gem 'seedbank'

# Search
gem 'ransack'

# Others
gem 'enumerize'
gem 'web-console'

group :development, :test do
  gem 'rspec-rails'
  gem 'dotenv', '>= 3.0'
  gem 'factory_bot_rails'
  gem 'brakeman', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
end

group :development do
  gem 'pry'
  gem 'bullet'
  gem 'lefthook'
  gem 'annotaterb'
  gem 'i18n-tasks'
  gem 'pgcli-rails'
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'rails-mermaid_erd'
  gem 'ruby-lsp'
  gem 'ruby-lsp-rails'
  gem 'bundler-audit', require: false
  gem 'rubocop', require: false
  gem 'rubocop-slim', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', '>= 2.22.0', require: false
end

group :test do
  gem 'vcr'
  gem 'webmock'
  gem 'capybara'
  gem 'pundit-matchers'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'rails-controller-testing'
end
