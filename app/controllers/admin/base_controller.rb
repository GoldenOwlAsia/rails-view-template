module Admin
  class BaseController < ApplicationController
    layout 'admin'

    before_action :authenticate_user!

    private

    def policy_scope(scope, policy_scope_class: nil, replace_parent_scope: false)
      super(replace_parent_scope ? scope : [:admin, scope], policy_scope_class: policy_scope_class)
    end

    def authorize(record, query = nil, policy_class: nil, replace_parent_scope: false)
      super(replace_parent_scope ? record : [:admin, record], query, policy_class: policy_class)
    end
  end
end
