module Spree
  module Stock
    module UnstockAssemblies
      private

      def unstock_inventory_units
        inventory_units.group_by(&:shipment_id).each_value do |inventory_units_for_shipment|
          inventory_units_for_shipment.group_by(&:line_item_id).each_value do |units|
            shipment = units.first.shipment
            line_item = units.first.line_item

            if line_item.product.assembly?
              units.group_by(&:variant_id).each_value do |units_for_part|
                part = units_for_part.first.variant
                shipment.stock_location.unstock part, units_for_part.count, shipment
              end
            else
              shipment.stock_location.unstock line_item.variant, units.count, shipment
            end
          end
        end
      end

      if Spree.solidus_gem_version >= Gem::Version.new('2.8')
        Spree::Stock::InventoryUnitsFinalizer.prepend self
      end
    end
  end
end
