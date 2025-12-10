if Rails.env.development?
  get '/erd', to: 'docs#erd'

  mount LetterOpenerWeb::Engine, at: '/emails'
end

authenticate :user, lambda { |u| u.has_role?(:super_admin) } do
  mount Sidekiq::Web => '/sidekiq'

  unless Rails.env.production?
    get 'admin/console', to: 'admin/console#index'
  end
end

get 'up' => 'rails/health#show', as: :rails_health_check
