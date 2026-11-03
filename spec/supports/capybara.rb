require 'capybara/rails'
require 'capybara/rspec'

RSpec.configure do |config|
  config.before(:each, type: :system) do
    # rack_test keeps system specs in-process: no browser, no server boot, and
    # transactional fixtures keep working. Switch to a real driver only for
    # specs that need JavaScript.
    driven_by :rack_test
  end
end
