# Renders one flash message as a daisyUI toast.
#
# The type -> colour/icon mapping is presentation behaviour that belongs with the
# markup, which is why this is a component rather than a partial plus a helper.
class FlashComponent < ApplicationComponent
  COLORS = {
    notice: 'bg-blue-200 text-blue-500 dark:bg-blue-800 dark:text-blue-200',
    alert: 'bg-red-200 text-red-500 dark:bg-red-800 dark:text-red-200',
    success: 'bg-green-200 text-green-500 dark:bg-green-800 dark:text-green-200',
    error: 'bg-red-200 text-red-500 dark:bg-red-800 dark:text-red-200'
  }.freeze

  ICONS = {
    alert: 'circle-alert',
    success: 'circle-check',
    error: 'circle-x'
  }.freeze

  DEFAULT_COLOR = 'bg-gray-200 text-gray-500 dark:bg-gray-800 dark:text-gray-200'.freeze
  DEFAULT_ICON = 'info'.freeze

  def initialize(type:, message:)
    super()
    @type = type.to_sym
    @message = message
  end

  private

  attr_reader :type, :message

  def color
    COLORS.fetch(type, DEFAULT_COLOR)
  end

  def icon
    ICONS.fetch(type, DEFAULT_ICON)
  end
end
