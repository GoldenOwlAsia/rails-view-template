module Users
  class Gather < ApplicationQuery
    def call(scope = User.all, **params)
      scope = filter(scope, :by_email, params[:email])
      sort(scope, params[:sort])
    end

    private

    # ApplicationQuery#filter already returns early when the value is blank and
    # invokes this as send(:by_email, scope, value), so the signature has to take
    # the scope and return a relation built from it.
    def by_email(scope, email)
      scope.where(email:)
    end
  end
end
