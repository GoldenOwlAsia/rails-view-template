authenticate :user, lambda { |u| u.has_role?(:super_admin) } do
  mount Sidekiq::Web => '/sidekiq'
  unless Rails.env.production?
    get 'admin/console', to: 'admin/console#index'
  end
end

namespace :admin do
  resources :users
  root to: 'users#index'
end
