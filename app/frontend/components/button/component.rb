# frozen_string_literal: true

class Button::Component < ApplicationViewComponent
  param :text, default: proc {}
  option :url, optional: true
  option :method, optional: true
  option :variant, default: proc { :primary }
  option :size, default: proc { :md }
  option :block, default: proc { false }
  option :type, default: proc { :button }
  option :disabled, default: proc { false }
  option :outline, default: proc { false }
  option :new_tab, default: proc { false }

  style do
    base do
      ['btn']
    end

    variants do
      variant do
        primary { ['btn-primary'] }
        secondary { ['btn-secondary'] }
        accent { ['btn-accent'] }
        info { ['btn-info'] }
        success { ['btn-success'] }
        warning { ['btn-warning'] }
        error { ['btn-error'] }
        ghost { ['btn-ghost'] }
        link { ['btn-link'] }
        white { ['bg-white hover:bg-gray-100'] }
      end

      size do
        sm { ['btn-sm'] }
        md { ['btn-md'] }
        lg { ['btn-lg'] }
      end

      disabled do
        yes { ['btn-disabled'] }
      end

      block do
        yes { ['btn-block'] }
      end

      outline do
        yes { ['btn-outline'] }
      end
    end
  end

  private

  def classes
    style(variant:, disabled:, size:, outline:, block:) + klass
  end

  def content
    text.presence || super
  end

  def button_kind
    return :link if url.present? && default_method?
    return :button_to if url.present? && !default_method?

    :button
  end

  def default_method?
    method.blank? || method == :get
  end

  def open_new?
    new_tab ? '_blank' : false
  end
end
