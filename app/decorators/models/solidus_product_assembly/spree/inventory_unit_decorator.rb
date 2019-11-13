module SolidusProductAssembly
  module Spree
    module InventoryUnit
      def percentage_of_line_item
        product = line_item.product
        if product.assembly?
          total_value = line_item.quantity_by_variant.map { |part, quantity| part.price * quantity }.sum
          variant.price / total_value
        else
          1 / BigDecimal.new(line_item.quantity)
        end
      end

      ::Spree::InventoryUnit.prepend self
    end
  end
end
