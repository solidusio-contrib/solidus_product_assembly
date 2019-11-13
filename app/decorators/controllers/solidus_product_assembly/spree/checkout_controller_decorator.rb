# frozen_string_literal: true

module SolidusProductAssembly
  module Spree
    module CheckoutControllerDecorator
      def before_payment; end

      if defined?(::Spree::CheckoutController)
        ::Spree::CheckoutController.prepend self
      end
    end
  end
end
