# frozen_string_literal: true

module IconsHelper
  def lucide_icon(name, options = {})
    tag.i('', data: { lucide: name }, class: (options[:class]).to_s)
  rescue StandardError
    tag.span(name.to_s.dasherize) + content_tag(:span, text, class: 'ms-1')
  end

  def svg_image_icon(name, options = {})
    tag.svg(read_svg_icon(name, type), data: { lucide: name }, class: (options[:class]).to_s)
  rescue StandardError
    tag.span(name.to_s.dasherize) + content_tag(:span, text, class: 'ms-1')
  end

  private

  def icons_path
    Rails.public_path.join('frontend/images/icons')
  end

  def read_svg_icon(filename)
    File.read("#{icons_path}/#{filename.dasherize}.svg")
  end
end
