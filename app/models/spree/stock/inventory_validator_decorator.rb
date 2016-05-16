module Spree
  module Stock
    class InventoryValidator < ActiveModel::Validator
      def validate(line_item)
        total_quantity = line_item.quantity_by_variant.values.sum

        if line_item.inventory_units.count != total_quantity
          line_item.errors[:inventory] << Spree.t(
              :inventory_not_available,
              item: line_item.variant.name
          )
        end
      end
    end
  end
end
