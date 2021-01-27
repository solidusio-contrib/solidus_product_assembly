# frozen_string_literal: true

class AddPositionToSpreeAssembliesParts < SolidusSupport::Migration[4.2]
  def up
    add_column :spree_assemblies_parts, :position, :integer, limit: 2

    product_ids = Spree::AssembliesPart.distinct(:assembly_id).pluck(:assembly_id)
    Spree::Product.with_discarded.where(id: product_ids).find_each do |product|
      product.assemblies_parts.each.with_index(1) do |part, index|
        part.update!(position: index)
      end
    end

    change_column :spree_assemblies_parts, :position, :integer, null: false, limit: 2
  end

  def down
    remove_column :spree_assemblies_parts, :position
  end
end
