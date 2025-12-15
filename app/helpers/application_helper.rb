module ApplicationHelper
  DASH_MASK = '--'.freeze

  def display_text(value)
    value.presence || DASH_MASK
  end

  def admin_menu_items
    [
      { path: admin_root_path, icon: 'chart-pie', label: 'Dashboard' },
      { path: admin_users_path, icon: 'users-round', label: 'Users' }
    ]
  end
end
