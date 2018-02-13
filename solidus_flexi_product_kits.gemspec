# encoding: UTF-8

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'solidus_flexi_product_kits/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_flexi_product_kits'
  s.version     = SolidusFlexiProductKits::VERSION
  s.summary     = 'Adds opportunity to make flexible product bundles to your Spree store'
  s.description = s.summary
  s.required_ruby_version = '>= 1.9.3'

  s.author            = 'Roman Smirnov'
  s.email             = 'roman@railsdog.com'
  s.homepage          = 'https://solidus.io'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_runtime_dependency 'solidus_backend', [">= 1.0", "< 3"]

  s.add_development_dependency 'rspec-rails', '~> 3.4'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'factory_bot', '~> 4.4'
  s.add_development_dependency 'capybara', '~> 2.7'
  s.add_development_dependency 'poltergeist', '~> 1.9'
  s.add_development_dependency 'database_cleaner', '~> 1.3'
  s.add_development_dependency 'simplecov'
end
