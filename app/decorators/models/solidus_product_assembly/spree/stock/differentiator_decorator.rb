# frozen_string_literal: true

module SolidusProductAssembly
  module Spree
    module Stock
      module DifferentiatorDecorator
        def build_missing
          super.tap do
            @missing.delete_if { |k, _v| k.product.assembly? }
          end
        end

        ::Spree::Stock::Differentiator.prepend self
      end
    end
  end
end
