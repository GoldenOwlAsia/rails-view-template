# frozen_string_literal: true

source 'https://rubygems.org'

gem 'bootsnap', require: false
gem 'good_migrations'
gem 'pg', '~> 1.5'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.2.0'
gem 'redis', '>= 4.0.1'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[windows jruby]
gem 'vite_rails', '~> 3.0'
gem 'image_processing'
gem 'enumerize'

# Auth
gem 'devise'
gem 'rolify'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'

# Policy
gem 'pundit', '~> 2.4'
gem 'active_storage_validations'

# Job
gem 'sidekiq'
gem 'sidekiq-unique-jobs'
gem 'sidekiq-scheduler'

# Seed
gem 'seedbank'
gem 'faker'

# Front-end
gem 'slim-rails', '~> 3.6', '>= 3.6.3'
gem 'simple_form'

# Pagination
gem 'pagy'

# Tracking
gem 'stackprof'
gem 'sentry-ruby'
gem 'sentry-rails'

gem 'web-console'

group :development, :test do
  gem 'brakeman', require: false
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'dotenv', '>= 3.0'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :development do
  gem 'annotate'
  gem 'bundler-audit', require: false
  gem 'lefthook'
  gem 'letter_opener'
  gem 'pgcli-rails'
  gem 'rubocop', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', '>= 2.22.0', require: false
  gem 'ruby-lsp'
  gem 'ruby-lsp-rails'
  gem 'bullet'
  gem 'rails-mermaid_erd'
  gem 'i18n-tasks'
end

group :test do
  gem 'capybara'
  gem 'shoulda-matchers'
  gem 'vcr'
  gem 'webmock'
  gem 'simplecov', require: false
  gem 'rails-controller-testing'
end
