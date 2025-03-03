# frozen_string_literal: true

Rails.application.routes.draw do
  if Rails.env.development?
    get '/erd', to: 'docs#erd'
  end

  authenticate :user, lambda { |u| u.has_role?(:super_admin) } do
    mount Sidekiq::Web => '/sidekiq'
    unless Rails.env.production?
      get 'admin/console', to: 'admin/console#index'
    end
  end

  devise_for :users,
    controllers: {
      sessions: 'authentication/sessions',
      registrations: 'authentication/registrations',
      omniauth_callbacks: 'authentication/omniauth_callbacks'
    }

  namespace :admin do
    resources :users

    root to: 'users#index'
  end

  namespace :employees do
    # Add employee routes here
  end

  root 'home#index'
  get 'up' => 'rails/health#show', as: :rails_health_check
end
