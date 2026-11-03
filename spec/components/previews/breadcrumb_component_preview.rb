# Previews for BreadcrumbComponent, browsable at /lookbook in development.
class BreadcrumbComponentPreview < ViewComponent::Preview
  def two_levels
    render BreadcrumbComponent.new(
      crumbs: [
        { name: 'Dashboard', path: '/admin' },
        { name: 'Users' }
      ]
    )
  end

  def three_levels
    render BreadcrumbComponent.new(
      crumbs: [
        { name: 'Dashboard', path: '/admin' },
        { name: 'Users', path: '/admin/users' },
        { name: 'Edit' }
      ]
    )
  end

  # A single crumb renders without any separator.
  def single
    render BreadcrumbComponent.new(crumbs: [{ name: 'Dashboard' }])
  end

  # The last crumb never links, even when a path is supplied.
  def last_crumb_with_path
    render BreadcrumbComponent.new(
      crumbs: [
        { name: 'Dashboard', path: '/admin' },
        { name: 'Users', path: '/admin/users' }
      ]
    )
  end
end
