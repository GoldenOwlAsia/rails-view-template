class UserParams
  class << self
    def permitted_attributes
      [
        :first_name,
        :last_name,
        :email,
        :password,
        :password_confirmation
      ]
    end
  end
end
