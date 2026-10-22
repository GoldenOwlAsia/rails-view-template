module Authentication
  class SessionsController < Devise::SessionsController
    protected

    def after_sign_in_path_for(resource)
      return root_path if resource.employee?
      return admin_root_path if resource.super_admin? || resource.admin?

      stored_location_for(resource) || root_path
    end
  end
end
