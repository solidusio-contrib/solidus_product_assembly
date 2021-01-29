# frozen_string_literal: true

module SolidusProductAssembly
  module Spree
    module Stock
      module InventoryValidatorDecorator
        def validate(line_item)
          total_quantity = line_item.quantity_by_variant.values.sum

          if line_item.inventory_units.count != total_quantity
            message = I18n.t('spree.inventory_not_available', item: line_item.variant.name)
            line_item.errors.add(:inventory, message: message)
          end
        end

        ::Spree::Stock::InventoryValidator.prepend self
      end
    end
  end
end
