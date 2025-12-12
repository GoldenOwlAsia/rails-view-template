class UserParams
  class << self
    def permitted_attributes
      [
        :email,
        :password,
        :password_confirmation,
        { role_ids: [] }
      ]
    end
  end
end
