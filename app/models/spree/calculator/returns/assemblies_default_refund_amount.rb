# frozen_string_literal: true

module Spree
  module Calculator::Returns
    class AssembliesDefaultRefundAmount < DefaultRefundAmount
      def compute(return_item)
        percentage = return_item.inventory_unit.percentage_of_line_item
        if percentage < 1 && return_item.variant.part?
          line_item = return_item.inventory_unit.line_item
          (super * percentage * line_item.quantity).round 4, :up
        else
          super
        end
      end
    end
  end
end
