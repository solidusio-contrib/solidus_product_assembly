# frozen_string_literal: true

module SolidusProductAssembly
  module Spree
    module VariantDecorator
      def self.prepended(base)
        base.class_eval do
          has_many :assemblies_parts,
            class_name: 'Spree::AssembliesPart',
            foreign_key: :part_id

          has_many :assemblies, through: :assemblies_parts
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
