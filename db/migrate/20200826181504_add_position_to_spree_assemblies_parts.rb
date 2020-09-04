class AddPositionToSpreeAssembliesParts < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_assemblies_parts, :position, :integer
  end
end
