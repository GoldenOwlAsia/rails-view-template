# frozen_string_literal: true

module IconsHelper
  def lucide_icon(name, options = {})
    tag.i('', data: { lucide: name }, class: options[:class].to_s, **options.except(:class))
  rescue StandardError => e
    content_tag(:span, "#{name.to_s.dasherize}: #{e}", class: 'ms-1')
  end
end
