class AddIdToSpreeAssembliesParts < SolidusSupport::Migration[4.2]
  def up
    add_column :spree_assemblies_parts, :id, :primary_key
  end

  def down
    remove_column :spree_assemblies_parts, :id
  end
end
