# Base class for ViewComponents.
#
# A component owns markup plus the presentation behaviour that drives it, and is
# rendered and tested on its own. Prefer it over a partial once the partial grows
# variants, or over a helper once the helper starts returning HTML.
#
# Templates live beside the class as a sidecar file:
#
#   app/components/flash_component.rb
#   app/components/flash_component.html.slim
#
class ApplicationComponent < ViewComponent::Base
end
