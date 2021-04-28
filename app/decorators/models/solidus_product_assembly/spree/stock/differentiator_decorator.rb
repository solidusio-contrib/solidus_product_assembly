module SolidusProductAssembly
  module Spree
    module Stock
      module DifferentiatorDecorator
        def build_required
          @required = Hash.new(0)
          order.line_items.reject { |line_item| line_item.product.assembly? }.each do |line_item|
            @required[line_item.variant] = line_item.quantity
          end
        end

        ::Spree::Stock::Differentiator.prepend self
      end
    end
  end
end
