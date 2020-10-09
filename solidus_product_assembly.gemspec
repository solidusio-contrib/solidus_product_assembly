# frozen_string_literal: true

$:.push File.expand_path('lib', __dir__)
require 'solidus_product_assembly/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_product_assembly'
  s.version     = SolidusProductAssembly::VERSION
  s.summary     = 'Adds oportunity to make bundle of products to your Spree store'
  s.description = s.summary
  s.license     = 'BSD-3-Clause'

  s.required_ruby_version = '>= 2.4'

  s.author            = 'Roman Smirnov'
  s.email             = 'roman@railsdog.com'
  s.homepage          = 'https://solidus.io'

  s.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  s.test_files = Dir['spec/**/*']
  s.bindir = "exe"
  s.executables = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  if s.respond_to?(:metadata)
    s.metadata["homepage_uri"] = s.homepage if s.homepage
    s.metadata["source_code_uri"] = s.homepage if s.homepage
  end

  s.add_dependency 'deface'
  s.add_dependency 'solidus_core', ['>= 1.0', '< 3']
  s.add_dependency 'solidus_support', '~> 0.5'

  s.add_development_dependency 'github_changelog_generator'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'solidus_dev_support'
end
