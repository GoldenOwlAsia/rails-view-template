require 'rails_helper'

RSpec.describe IconsHelper do
  describe '#lucide_icon' do
    it 'returns an <i> tag with lucide icon name' do
      result = helper.lucide_icon(:check_circle, class: 'icon-class')

      expect(result).to have_css('i[data-lucide="check_circle"][class="icon-class"]')
    end

    it 'returns a fallback <span> tag when there is an error' do
      allow(helper).to receive(:tag).and_raise(StandardError)
      result = helper.lucide_icon(:non_existent_icon)
      expect(result).to have_css('span[class="ms-1"]')
    end
  end
end
