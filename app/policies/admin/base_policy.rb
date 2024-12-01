module Admin
  class BasePolicy < ApplicationPolicy
    def index?
      admin?
    end

    def show?
      admin?
    end

    def create?
      admin?
    end

    def update?
      admin?
    end

    def destroy?
      admin?
    end

    private

    def admin?
      @user.admin?
    end
  end
end
