# frozen_string_literal: true

module Spree
  module Calculator::Returns
    class AssembliesDefaultRefundAmount < DefaultRefundAmount
      def compute(return_item)
        percentage = return_item.inventory_unit.percentage_of_line_item
        if percentage < 1 && return_item.variant.part?
          (super * percentage * variants_count(return_item)).round 4, :up
        else
          super
        end
      end

      def variants_count(return_item)
        inventory_unit = return_item.inventory_unit
        line_item = inventory_unit.line_item
        line_item.inventory_units.where(variant_id: inventory_unit.variant_id).count
      end
    end
  end
end
