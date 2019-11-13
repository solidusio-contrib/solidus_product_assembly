# frozen_string_literal: true

module SolidusProductAssembly
  module Spree
    module ReturnItemDecorator
      def self.prepended(base)
        base.class_eval do
          self.refund_amount_calculator = ::Spree::Calculator::Returns::AssembliesDefaultRefundAmount
        end
      end

      ::Spree::ReturnItem.prepend self
    end
  end
end
