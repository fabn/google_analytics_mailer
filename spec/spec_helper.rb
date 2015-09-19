ENV['RAILS_ENV'] ||= 'test'
require 'coveralls'
Coveralls.wear!

# Gem main file
require 'google_analytics_mailer'
require 'active_support/all'
require 'email_spec'
require 'capybara/dsl'
require 'capybara/rspec/matchers'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

# Configure action mailer for test deliveries
ActionMailer::Base.delivery_method = :test
# Configure action mailer view path
ActionMailer::Base.view_paths = File.join(File.dirname(__FILE__), 'support', 'views')

RSpec.configure do |config|

  config.include EmailSpec::Helpers
  config.include EmailSpec::Matchers
  config.include Capybara::RSpecMatchers

end
