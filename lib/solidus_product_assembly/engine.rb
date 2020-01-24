# frozen_string_literal: true

require 'spree/core'

module SolidusProductAssembly
  class Engine < Rails::Engine
    include SolidusSupport::EngineExtensions::Decorators

    isolate_namespace ::Spree

    engine_name 'solidus_product_assembly'

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
