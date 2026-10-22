if Rails.env.development?
  get '/erd', to: 'docs#erd'

  mount LetterOpenerWeb::Engine, at: '/emails'

  # Component previews. The gem is in the :development group, so this constant
  # does not exist in any other environment.
  mount Lookbook::Engine, at: '/lookbook'
end

authenticate :user, lambda { |u| u.has_role?(:super_admin) } do
  mount Sidekiq::Web => '/sidekiq'

  unless Rails.env.production?
    get 'admin/console', to: 'admin/console#index'
  end
end

get 'up' => 'rails/health#show', as: :rails_health_check
