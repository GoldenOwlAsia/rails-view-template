module Users
  class Gather < ApplicationQuery
    def call(scope = User.all, **params)
      scope = filter(scope, :by_email, params[:email])
      sort(scope, params[:sort])
    end

    private

    def by_email(email)
      return self if email.blank?

      where(email: email)
    end
  end
end
