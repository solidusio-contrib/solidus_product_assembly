# frozen_string_literal: true

module SolidusProductAssembly
  module Spree
    module VariantDecorator
      def self.prepended(base)
        base.class_eval do
          has_and_belongs_to_many :assemblies,
            class_name: "Spree::Product",
            join_table: "spree_assemblies_parts",
            foreign_key: "part_id", association_foreign_key: "assembly_id"
        end
      end

      def assemblies_for(products)
        assemblies.where(id: products)
      end

      def part?
        assemblies.exists?
      end

      ::Spree::Variant.prepend self
    end
  end
end
