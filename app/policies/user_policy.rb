class UserPolicy < ApplicationPolicy
  def permitted_attributes
    [
      :email,
      :password,
      :password_confirmation,
      {
        role_ids: []
      }
    ]
  end

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

  class Scope < Scope
    def resolve
      scope.order(created_at: :desc)
    end
  end
end
