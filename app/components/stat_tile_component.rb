# A single dashboard metric: a label, a value, and an optional leading icon.
#
# The dashboard had this block copy-pasted seven times, differing only in those
# three things.
#
#   render StatTileComponent.new(label: 'Total users', value: 42, icon: 'users')
#   render StatTileComponent.new(label: 'Avg. / month', value: 7)
class StatTileComponent < ApplicationComponent
  def initialize(label:, value:, icon: nil)
    super()
    @label = label
    @value = value
    @icon = icon
  end

  private

  attr_reader :label, :value, :icon

  def icon? = icon.present?

  # The icon-less tiles carried an extra top margin on the value, because there
  # is no icon box setting the header row's height. Preserved so the two
  # variants line up exactly as they did before.
  def value_classes
    ['text-xl font-semibold text-base-content', ('mt-1' unless icon?)].compact.join(' ')
  end
end
