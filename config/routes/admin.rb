namespace :admin do
  root to: 'dashboard#index'

  resources :users
end
