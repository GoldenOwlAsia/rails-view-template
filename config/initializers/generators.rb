Rails.application.config.generators do |g|
  g.factory_bot suffix: 'factory'
  g.view_specs false
  g.javascripts false
  g.stylesheets false
  g.routing_specs false
  g.orm :active_record, primary_key_type: :uuid
end
