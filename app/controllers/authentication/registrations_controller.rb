module Authentication
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_permitted_parameters

    protected

    def after_update_path_for(_resource)
      sign_in_after_change_password? ? edit_user_registration_path : new_session_path(resource_name)
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:account_update, keys: [:avatar])
    end

    def update_resource(resource, params)
      params.compact_blank!
      resource.send(params.keys == ['avatar'] ? :update : :update_with_password, params)
    end
  end
end
