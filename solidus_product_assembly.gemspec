# frozen_string_literal: true

require_relative 'lib/solidus_product_assembly/version'

Gem::Specification.new do |spec|
  spec.name = 'solidus_product_assembly'
  spec.version = SolidusProductAssembly::VERSION
  spec.authors = ['Roman Smirnov']
  spec.email = 'roman@railsdog.com'

  spec.summary = 'Make bundle of products to your Solidus store'
  spec.description = 'Make bundle of products to your Solidus store'
  spec.homepage = 'https://github.com/solidusio-contrib/solidus_product_assembly'
  spec.license = 'BSD-3-Clause'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/solidusio-contrib/solidus_product_assembly'
  spec.metadata['changelog_uri'] = 'https://github.com/solidusio-contrib/solidus_product_assembly/releases'

  spec.required_ruby_version = Gem::Requirement.new('>= 2.5', '< 4')

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  files = Dir.chdir(__dir__) { `git ls-files -z`.split("\x0") }

  spec.files = files.grep_v(%r{^(test|spec|features)/})
  spec.test_files = files.grep(%r{^(test|spec|features)/})
  spec.bindir = "exe"
  spec.executables = files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'solidus_core', '>= 3.2'
  spec.add_dependency 'solidus_support', '~> 0.8'
  spec.add_dependency 'deface'

  spec.add_development_dependency 'solidus_dev_support', '~> 2.5'
end
