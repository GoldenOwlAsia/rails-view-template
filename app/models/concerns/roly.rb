module Roly
  extend ActiveSupport::Concern

  def includes_role?(role_name, resource = nil)
    roles.loaded? ? has_cached_role?(role_name, resource) : has_role?(role_name, resource)
  end
end
