require 'simplecov'
SimpleCov.start 'rails'

ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'solidus_support/extension/feature_helper'

Capybara.register_driver :selenium_chrome_headless do |app|
  browser_options = ::Selenium::WebDriver::Chrome::Options.new
  browser_options.args << '--headless'
  browser_options.args << '--disable-gpu'
  browser_options.args << '--window-size=1440,1080'
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: browser_options)
end


Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each {|f| require f }

RSpec.configure do |config|
  config.mock_with :rspec

  config.before :suite do
    Capybara.match = :prefer_exact
  end

  config.prepend_before(:each) do
    Rails.cache.clear
  end

  config.example_status_persistence_file_path = "./spec/examples.txt"
end
