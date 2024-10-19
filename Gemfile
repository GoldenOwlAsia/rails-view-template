# frozen_string_literal: true

source 'https://rubygems.org'

gem 'bootsnap', require: false
gem 'good_migrations'
gem 'pg', '~> 1.1'
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

# Policy
gem 'pundit', '~> 2.4'
gem 'active_storage_validations'

# Job
gem 'sidekiq'
gem 'sidekiq-unique-jobs'
gem 'sidekiq-scheduler'

# Seed
gem 'seedbank'

# Front-end
gem 'slim-rails', '~> 3.6', '>= 3.6.3'
gem 'dry-initializer', '~> 3.1'
gem 'dry-types', '~> 1.7', '>= 1.7.2'
gem 'view_component', '~> 3.17'
gem 'view_component-contrib', '~> 0.2.3'
gem 'simple_form'

# Pagination
gem 'pagy'

# Tracking
gem 'stackprof'
gem 'sentry-ruby'
gem 'sentry-rails'

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
  gem 'lookbook'
  gem 'pgcli-rails'
  gem 'rubocop', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', '>= 2.22.0', require: false
  gem 'ruby-lsp'
  gem 'ruby-lsp-rails'
  gem 'web-console'
  gem 'bullet'
end

group :test do
  gem 'capybara'
  gem 'shoulda-matchers'
  gem 'vcr'
  gem 'webmock'
end
