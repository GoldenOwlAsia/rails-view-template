# Previews for StatTileComponent, browsable at /lookbook in development.
class StatTileComponentPreview < ViewComponent::Preview
  # @param label text
  # @param value text
  # @param icon text
  def with_icon(label: 'Total users', value: '1,284', icon: 'users')
    render StatTileComponent.new(label:, value:, icon:)
  end

  # No icon: the value picks up a top margin so the two variants align.
  def without_icon
    render StatTileComponent.new(label: 'Avg. / month', value: '107')
  end

  # The four icon tiles as the dashboard arranges them.
  def dashboard_row
    render_with_template(
      locals: {
        tiles: [
          { label: 'Total users', value: '1,284', icon: 'users' },
          { label: 'New this year', value: '312', icon: 'calendar' },
          { label: 'New this month', value: '48', icon: 'plus-circle' },
          { label: 'New today', value: '6', icon: 'clock' }
        ]
      }
    )
  end
end
