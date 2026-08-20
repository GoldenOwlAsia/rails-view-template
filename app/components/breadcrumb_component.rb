# Admin breadcrumb trail.
#
# Takes the crumbs as data and owns the decisions the markup depends on: which
# crumb is current, which renders as a link, and where the separator goes.
#
#   render BreadcrumbComponent.new(crumbs: [
#     { name: 'Dashboard', path: admin_root_path },
#     { name: 'Users' }
#   ])
class BreadcrumbComponent < ApplicationComponent
  # Application helpers are not mixed into a component. Delegate the ones the
  # template needs so the dependency is visible in the class.
  delegate :lucide_icon, to: :helpers

  Crumb = Struct.new(:name, :path, :current, keyword_init: true) do
    def link? = path.present? && !current
  end

  def initialize(crumbs:)
    super()
    @crumbs = crumbs
  end

  private

  attr_reader :crumbs

  # The last crumb is the current page: it never links, and it carries
  # aria-current so assistive technology can announce it.
  def entries
    last = crumbs.size - 1

    crumbs.each_with_index.map do |crumb, index|
      Crumb.new(name: crumb[:name], path: crumb[:path], current: index == last)
    end
  end
end
