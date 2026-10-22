require 'rails_helper'

RSpec.describe FlashComponent do
  def render_flash(type:, message: 'Something happened')
    render_inline(described_class.new(type:, message:))
  end

  it 'renders the message' do
    render_flash(type: :notice, message: 'Saved')

    expect(page).to have_text('Saved')
  end

  it 'accepts a string type as well as a symbol' do
    render_flash(type: 'success')

    expect(page).to have_css(".#{described_class::COLORS[:success].split.first}")
  end

  describe 'colour' do
    it 'uses the mapped classes for a known type' do
      render_flash(type: :alert)

      expect(page).to have_css(".#{described_class::COLORS[:alert].split.first}")
    end

    it 'falls back to the default classes for an unknown type' do
      render_flash(type: :something_else)

      expect(page).to have_css(".#{described_class::DEFAULT_COLOR.split.first}")
    end
  end

  describe 'icon' do
    it 'uses the mapped icon for a known type' do
      render_flash(type: :error)

      expect(page).to have_css('i[data-lucide="circle-x"]')
    end

    it 'falls back to the default icon for an unknown type' do
      render_flash(type: :notice)

      expect(page).to have_css(%(i[data-lucide="#{described_class::DEFAULT_ICON}"]))
    end
  end

  it 'keeps the dismiss control wired to the notification controller' do
    render_flash(type: :notice)

    expect(page).to have_css('button[data-action="notification#hide"]')
  end
end
