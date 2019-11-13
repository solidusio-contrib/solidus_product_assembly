# encoding: UTF-8

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'solidus_product_assembly/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_product_assembly'
  s.version     = SolidusProductAssembly::VERSION
  s.summary     = 'Adds oportunity to make bundle of products to your Spree store'
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
  s.add_runtime_dependency 'deface'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'puma'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency "github_changelog_generator"
end
