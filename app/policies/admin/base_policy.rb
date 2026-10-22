module Admin
  class BasePolicy < ApplicationPolicy
    def index?
      user.super_admin? || user.admin?
    end

    alias show? index?
    alias create? index?
    alias update? index?
    alias new? index?
    alias edit? index?
    alias destroy? index?

    class Scope < Scope
      def resolve
        scope.order(created_at: :desc)
      end
    end
  end
end
