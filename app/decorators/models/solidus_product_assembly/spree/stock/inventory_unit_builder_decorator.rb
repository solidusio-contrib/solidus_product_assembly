# frozen_string_literal: true

module SolidusProductAssembly
  module Spree
    module Stock
      module InventoryUnitBuilderDecorator
        def units
          @order.line_items.flat_map do |line_item|
            line_item.quantity_by_variant.flat_map do |variant, quantity|
              quantity.times.map { build_inventory_unit(variant, line_item) }
            end
          end
        end

        def build_inventory_unit(variant, line_item)
          inventory_unit_attributes = {
            pending: true,
            variant: variant,
            line_item: line_item,
          }
          if SolidusSupport.solidus_gem_version < Gem::Version.new('2.5.x')
            inventory_unit_attributes[:order] = @order
          end
          @order.inventory_units.includes(
            variant: {
              product: {
                shipping_category: {
                  shipping_methods: [:calculator, { zones: :zone_members }]
                }
              }
            }
          ).build(inventory_unit_attributes)
        end

        ::Spree::Stock::InventoryUnitBuilder.prepend self
      end
    end
  end
end
