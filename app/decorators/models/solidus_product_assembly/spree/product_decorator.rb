# frozen_string_literal: true

module SolidusProductAssembly
  module Spree
    module ProductDecorator
      def self.prepended(base)
        base.class_eval do
          has_many :assemblies_parts,
            -> { order(:position) },
            class_name: 'Spree::AssembliesPart',
            foreign_key: :assembly_id

          has_many :parts, through: :assemblies_parts

          scope :individual_saled, -> { where(individual_sale: true) }

          scope :search_can_be_part, lambda { |query|
            not_deleted
              .available
              .joins(:master)
              .where(arel_table['name'].matches("%#{query}%").or(::Spree::Variant.arel_table['sku'].matches("%#{query}%")))
              .where(can_be_part: true)
              .limit(30)
          }

          validate :assembly_cannot_be_part, if: :assembly?
        end
      end

      def add_part(variant, count = 1)
        set_part_count(variant, count_of(variant) + count)
      end

      def remove_part(variant)
        set_part_count(variant, 0)
      end

      def set_part_count(variant, count)
        ap = assemblies_part(variant)
        count > 0 ? ap.update(count: count) : ap.destroy
        reload
      end

      def assembly?
        parts.present?
      end

      def count_of(variant)
        ap = assemblies_part(variant)
        # This checks persisted because the default count is 1
        ap.persisted? ? ap.count : 0
      end

      def assembly_cannot_be_part
        errors.add(:can_be_part, I18n.t('spree.assembly_cannot_be_part')) if can_be_part
      end

      private

      def assemblies_part(variant)
        ::Spree::AssembliesPart.get(id, variant.id)
      end

      ::Spree::Product.prepend self
    end
  end
end
