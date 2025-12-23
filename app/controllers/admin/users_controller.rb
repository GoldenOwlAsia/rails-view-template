module Admin
  class UsersController < BaseController
    include Crudable

    COLLECTION_INCLUDES = [
      :avatar_attachment
    ].freeze

    crud_to class: User,
      searchable: true,
      collection_variable: :@users,
      collection_includes: COLLECTION_INCLUDES

    private

    def resource_permitted_params
      params.expect(user: UserParams.permitted_attributes)
    end
  end
end
