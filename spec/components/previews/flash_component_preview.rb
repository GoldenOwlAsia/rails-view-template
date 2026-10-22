# Previews for FlashComponent, browsable at /lookbook in development.
class FlashComponentPreview < ViewComponent::Preview
  # @param message text
  def notice(message: 'Your changes have been saved.')
    render FlashComponent.new(type: :notice, message:)
  end

  def alert
    render FlashComponent.new(type: :alert, message: 'Invalid Email or password.')
  end

  def success
    render FlashComponent.new(type: :success, message: 'User created successfully.')
  end

  def error
    render FlashComponent.new(type: :error, message: 'Something went wrong.')
  end

  # Any unmapped type falls back to the grey palette and the info icon.
  def unknown_type
    render FlashComponent.new(type: :whatever, message: 'Falls back to the default styling.')
  end
end
