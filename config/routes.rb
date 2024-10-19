# frozen_string_literal: true

Rails.application.routes.draw do
  if Rails.env.development?
    mount Lookbook::Engine, at: '/lookbook'
  end

  authenticate :user, lambda { |u| u.has_role?(:super_admin) } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users

  root 'home#index'
  get 'up' => 'rails/health#show', as: :rails_health_check
end
