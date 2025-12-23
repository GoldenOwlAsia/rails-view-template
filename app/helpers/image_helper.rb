module ImageHelper
  def attachment_image_tag(source, options = {})
    if (source.respond_to?(:attached?) && source.attached?) || source.present?
      image_tag(source, options)
    else
      default_image = options.delete(:default) || 'images/icons/logo.svg'
      vite_image_tag(default_image, alt: 'default image', **options)
    end
  end
end
