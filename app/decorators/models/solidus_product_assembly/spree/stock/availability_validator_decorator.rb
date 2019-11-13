# frozen_string_literal: true

module SolidusProductAssembly
  module Spree
    module Stock
      # Overridden from spree core to make it also check for assembly parts stock
      module AvailabilityValidatorDecorator
        def validate(line_item)
          if line_item.product.assembly?
            line_item.quantity_by_variant.each do |variant, variant_quantity|
              inventory_units = line_item.inventory_units.where(variant: variant).count
              quantity = variant_quantity - inventory_units
              next if quantity <= 0
              next unless variant

              quantifier = ::Spree::Stock::Quantifier.new(variant)

              next if quantifier.can_supply? quantity

              display_name = variant.name.to_s
              display_name += %{ (#{variant.options_text})} if variant.options_text.present?

              line_item.errors[:quantity] << I18n.t(
                'spree.selected_quantity_not_available',
                item: display_name.inspect
              )
            end
          else
            super
          end
        end

        ::Spree::Stock::AvailabilityValidator.prepend self
      end
    end
  end
end
