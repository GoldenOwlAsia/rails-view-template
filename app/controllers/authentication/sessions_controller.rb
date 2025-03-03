module Authentication
  class SessionsController < Devise::SessionsController
    protected

    def after_sign_in_path_for(resource)
      return admin_root_path if resource.admin?
      return employee_root_path if resource.employee?

      stored_location_for(resource) || root_path
    end
  end
end
