require 'view_component/test_helpers'

RSpec.configure do |config|
  # infer_spec_type_from_file_location! only knows Rails' own directories, so
  # spec/components has to be registered for :component to be inferred. Keeps
  # component specs consistent with the rest of the suite: no explicit type:.
  config.define_derived_metadata(file_path: %r{/spec/components/}) do |metadata|
    metadata[:type] ||= :component
  end

  config.include ViewComponent::TestHelpers, type: :component
end
