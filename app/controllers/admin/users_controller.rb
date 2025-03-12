module Admin
  class UsersController < BaseController
    include Crudable

    crud_to class: User,
      collection_variable: :@users,
      object_variable: :@user,
      collection_path: :admmin_users_path,
      object_path: :admin_user_path,
      searchable: true,
      modal_form: false,
      # collection_includes:,
      flash_messages: {
        created: I18n.t('common.create.success', model: :user),
        updated: I18n.t('common.update.success', model: :user),
        deleted: I18n.t('common.delete.success', model: :user)
      }
  end
end
