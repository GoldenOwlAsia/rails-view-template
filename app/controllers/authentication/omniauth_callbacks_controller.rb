module Authentication
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    before_action :set_user

    def google_oauth2
      oauth_callback('google')
    end

    def facebook
      oauth_callback('facebook')
    end

    private

    def auth
      @auth ||= request.env['omniauth.auth']
    end

    def set_user
      @user ||= User.find_by(uid: auth.uid, provider: auth.provider) || User.find_by(email: auth.info.email)
    end

    def oauth_callback(provider)
      unless auth
        flash[:alert] = t('devise.omniauth_callbacks.failure', kind: provider.capitalize, reason: 'Authentication data is missing')
        return redirect_to root_path
      end

      user = @user || find_or_create_user

      if user&.persisted?
        flash[:notice] = t('devise.omniauth_callbacks.success', kind: provider.capitalize)
        sign_in_and_redirect user, event: :authentication
      else
        flash[:alert] = t('devise.omniauth_callbacks.failure', kind: provider.capitalize, reason: 'User does not belong to the organization')
        redirect_to root_path
      end
    end

    def find_or_create_user
      User.create(
        uid: auth.uid,
        provider: auth.provider,
        email: auth.info.email.presence || "#{auth.provider}_#{Devise.friendly_token[8, 11]}@gmail.com",
        password: "#{Devise.friendly_token[0, 20]}A@1a",
        confirmed_at: Time.current
      )
    end
  end
end
