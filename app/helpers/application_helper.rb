module ApplicationHelper
  DASH_MASK = '--'.freeze

  def display_text(value)
    value.presence || DASH_MASK
  end
end
