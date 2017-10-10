require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'
require 'ffaker'
require 'database_cleaner'

require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'
Capybara.register_driver(:poltergeist) do |app|
  Capybara::Poltergeist::Driver.new app, timeout: 90
end
Capybara.javascript_driver = :poltergeist
Capybara.default_max_wait_time = 10

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each {|f| require f }

require 'spree/testing_support/factories'
require 'spree/testing_support/url_helpers'
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/capybara_ext'

# ActiveRecord::Base.logger = Logger.new(STDOUT)

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = false

  config.before :suite do
    Capybara.match = :prefer_exact
    DatabaseCleaner.clean_with :truncation
  end

  config.prepend_before(:each) do
    Rails.cache.clear

    if RSpec.current_example.metadata[:js]
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
    end

    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end

  config.include FactoryGirl::Syntax::Methods
  config.include Spree::TestingSupport::UrlHelpers
  config.example_status_persistence_file_path = "./spec/examples.txt"
end
