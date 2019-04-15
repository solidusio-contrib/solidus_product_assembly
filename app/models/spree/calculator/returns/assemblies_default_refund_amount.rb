# frozen_string_literal: true

module Spree
  module Calculator::Returns
    class AssembliesDefaultRefundAmount < DefaultRefundAmount
      def compute(return_item)
        super * return_item.inventory_unit.percentage_of_line_item
      end
    end
  end
end
