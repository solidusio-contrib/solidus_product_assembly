# frozen_string_literal: true

module SolidusProductAssembly
  module Spree
    module ReturnItemDecorator
      include ActiveSupport::Concern

      prepended do
        self.refund_amount_calculator = ::Spree::Calculator::Returns::AssembliesDefaultRefundAmount
      end

      ::Spree::ReturnItem.prepend self
    end
  end
end
