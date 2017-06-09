class NamespaceProductAssemblyForSpreeOne < SolidusSupport::Migration[4.2]
  def up
    rename_table :assemblies_parts, :spree_assemblies_parts
  end

  def down
    rename_table :spree_assemblies_parts, :assemblies_parts
  end
end
