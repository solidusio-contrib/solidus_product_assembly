# frozen_string_literal: true

require_relative 'lib/solidus_product_assembly/version'

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name = 'solidus_product_assembly'
  s.version = SolidusProductAssembly::VERSION
  s.authors = ['Roman Smirnov']
  s.email = 'roman@railsdog.com'

  s.summary = 'Adds opportunity to make bundle of products to your Spree store'
  s.description = s.summary
  s.homepage = 'https://solidus.io'
  s.license = 'BSD-3-Clause'

  s.metadata['homepage_uri'] = s.homepage
  s.metadata['source_code_uri'] = 'https://github.com/solidusio-contrib/solidus_product_assembly'
  s.metadata['changelog_uri'] = 'https://github.com/SuperGoodSoft/solidus_product_assembly/blob/master/CHANGELOG.md'

  s.required_ruby_version = '>= 2.4'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }

  s.files = files.grep_v(%r{^(test|spec|features)/})
  s.test_files = files.grep(%r{^(test|spec|features)/})
  s.bindir = "exe"
  s.executables = files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'solidus_core', ['>= 2.0.0', '< 5']
  s.add_dependency 'solidus_support', '~> 0.8'
  s.add_dependency 'deface'

  s.add_development_dependency 'solidus_dev_support', '~> 2.5'
  s.add_development_dependency 'github_changelog_generator'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'webdrivers'
end
