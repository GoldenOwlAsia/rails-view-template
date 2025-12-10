devise_for(
  :users,
  controllers: {
    sessions: 'authentication/sessions',
    registrations: 'authentication/registrations',
    omniauth_callbacks: 'authentication/omniauth_callbacks'
  }
)
