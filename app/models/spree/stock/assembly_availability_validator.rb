module Spree
  module Stock
    module AssemblyAvailabilityValidator
      def validate(line_item)

        return super unless line_item.product.assembly?

        line_item.quantity_by_variant.each do |variant, variant_quantity|
          inventory_units = line_item.inventory_units.where(variant: variant).count
          quantity = variant_quantity - inventory_units

          next if quantity <= 0
          next unless variant

          quantifier = Stock::Quantifier.new(variant)
          unless quantifier.can_supply? quantity
            display_name = %Q{#{variant.name}}
            display_name += %Q{ (#{variant.options_text})} unless variant.options_text.blank?

            line_item.errors[:quantity] << Spree.t(
              :selected_quantity_not_available,
              item: display_name.inspect
            )
          end
        end
      end
    end
  end
end
