namespace :admin do
  resources :users
  root to: 'users#index'
end
