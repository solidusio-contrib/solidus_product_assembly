# frozen_string_literal: true

module Spree
  # This class has basically the same functionality of Spree core OrderInventory
  # except that it takes account of bundle parts and properly creates and removes
  # inventory unit for each parts of a bundle
  class OrderInventoryAssembly < OrderInventory
    attr_reader :product

    def initialize(line_item)
      @order = line_item.order
      @line_item = line_item
      @product = line_item.product
    end

    def verify(shipment = nil)
      if order.completed? || shipment.present?
        line_item.quantity_by_variant.each do |part, total_parts|
          existing_parts = line_item.inventory_units.where(variant: part).count

          self.variant = part

          if existing_parts < total_parts
            quantity = total_parts - existing_parts
            shipment ||= determine_target_shipment(quantity)
            add_to_shipment(shipment, quantity)
          elsif existing_parts > total_parts
            quantity = existing_parts - total_parts
            if shipment.present?
              remove_from_shipment(shipment, quantity)
            else
              order.shipments.each do |shipment|
                break if quantity == 0

                quantity -= remove_from_shipment(shipment, quantity)
              end
            end
          end
        end
      end
    end
  end
end
