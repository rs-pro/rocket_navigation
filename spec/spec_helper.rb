require "bundler/setup"

require 'simplecov'
SimpleCov.start

require 'rails'
require 'fake_app/rails_app'
require 'rspec/rails'

require "rocket_navigation"

Bundler.require

require 'capybara/rspec'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each do |f|
  require f
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.order = :random

  config.include Helpers
end

