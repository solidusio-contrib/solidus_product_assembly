# frozen_string_literal: true

module SolidusProductAssembly
  module Spree
    module Admin
      module OrdersHelperDecorator
        def self.prepended(base)
          base.module_eval do
            def line_item_shipment_price(line_item, quantity)
              ::Spree::Money.new(line_item.price * quantity, currency: line_item.currency)
            end
          end
        end

        ::Spree::Admin::OrdersHelper.prepend self
      end
    end
  end
end
