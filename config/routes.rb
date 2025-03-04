# frozen_string_literal: true

Rails.application.routes.draw do
  if Rails.env.development?
    get '/erd', to: 'docs#erd'
  end

  devise_for :users,
    controllers: {
      sessions: 'authentication/sessions',
      registrations: 'authentication/registrations',
      omniauth_callbacks: 'authentication/omniauth_callbacks'
    }

  draw :admin
  draw :employee

  root 'home#index'
  get 'up' => 'rails/health#show', as: :rails_health_check
end
