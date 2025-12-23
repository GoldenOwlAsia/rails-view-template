devise_for(
  :users,
  skip: [:registrations],
  controllers: {
    sessions: 'authentication/sessions',
    passwords: 'authentication/passwords',
    confirmations: 'authentication/confirmations',
    registrations: 'authentication/registrations',
    omniauth_callbacks: 'authentication/omniauth_callbacks'
  }
)

devise_scope :user do
  get '/users/sign_up', to: 'authentication/registrations#new'
  post '/users/sign_up', to: 'authentication/registrations#create'
end
