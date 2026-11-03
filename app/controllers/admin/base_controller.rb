module Admin
  class BaseController < ApplicationController
    layout 'admin'

    before_action :authenticate_admin!

    private

    def policy_scope(scope, policy_scope_class: nil)
      super([:admin, scope], policy_scope_class:)
    end

    def authorize(record, query = nil, policy_class: nil)
      super([:admin, record], query, policy_class:)
    end

    def authenticate_admin!
      redirect_to root_path, alert: 'Access denied.' unless current_user&.admin? || current_user&.super_admin?
    end
  end
end
