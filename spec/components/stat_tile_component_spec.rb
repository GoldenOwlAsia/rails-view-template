require 'rails_helper'

RSpec.describe StatTileComponent do
  it 'renders the label and the value', :aggregate_failures do
    render_inline(described_class.new(label: 'Total users', value: 42))

    expect(page).to have_text('Total users')
    expect(page).to have_text('42')
  end

  it 'renders the icon when one is given' do
    render_inline(described_class.new(label: 'Total users', value: 42, icon: 'users'))

    expect(page).to have_css('i[data-lucide="users"]')
  end

  it 'renders no icon element when none is given' do
    render_inline(described_class.new(label: 'Avg. / month', value: 7))

    expect(page).to have_no_css('i[data-lucide]')
  end

  it 'treats a blank icon as no icon' do
    render_inline(described_class.new(label: 'Avg. / month', value: 7, icon: ''))

    expect(page).to have_no_css('i[data-lucide]')
  end

  describe 'value spacing' do
    it 'adds no top margin when there is an icon to set the header height' do
      render_inline(described_class.new(label: 'Total users', value: 42, icon: 'users'))

      expect(page).to have_no_css('p.mt-1')
    end

    it 'adds a top margin when there is no icon' do
      render_inline(described_class.new(label: 'Avg. / month', value: 7))

      expect(page).to have_css('p.mt-1')
    end
  end

  it 'renders a non-numeric value as given' do
    render_inline(described_class.new(label: 'This month vs last', value: '+12%'))

    expect(page).to have_text('+12%')
  end
end
