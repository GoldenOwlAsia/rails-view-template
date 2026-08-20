require 'rails_helper'

RSpec.describe BreadcrumbComponent do
  let(:crumbs) do
    [
      { name: 'Dashboard', path: '/admin' },
      { name: 'Users', path: '/admin/users' },
      { name: 'Edit' }
    ]
  end

  it 'renders every crumb' do
    render_inline(described_class.new(crumbs:))

    expect(page).to have_text('Dashboard').and have_text('Users').and have_text('Edit')
  end

  it 'links the crumbs that have a path and are not current', :aggregate_failures do
    render_inline(described_class.new(crumbs:))

    expect(page).to have_link('Dashboard', href: '/admin')
    expect(page).to have_link('Users', href: '/admin/users')
  end

  it 'never links the last crumb, even when it has a path', :aggregate_failures do
    render_inline(
      described_class.new(
        crumbs: [
          { name: 'Dashboard', path: '/admin' },
          { name: 'Users', path: '/admin/users' }
        ]
      )
    )

    expect(page).to have_no_link('Users')
    expect(page).to have_css('span', text: 'Users')
  end

  it 'marks the last crumb as the current page' do
    render_inline(described_class.new(crumbs:))

    expect(page).to have_css('li[aria-current="page"]', text: 'Edit')
  end

  it 'marks only the last crumb as current' do
    render_inline(described_class.new(crumbs:))

    expect(page).to have_css('li[aria-current="page"]', count: 1)
  end

  it 'puts a separator between crumbs but not before the first' do
    render_inline(described_class.new(crumbs:))

    expect(page).to have_css('i[data-lucide="chevron-right"]', count: crumbs.size - 1)
  end

  it 'renders a single crumb with no separator' do
    render_inline(described_class.new(crumbs: [{ name: 'Dashboard' }]))

    expect(page).to have_no_css('i[data-lucide="chevron-right"]')
  end
end
