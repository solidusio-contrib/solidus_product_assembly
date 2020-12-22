# frozen_string_literal: true

module Spree
  # Join model between Assembly (Product) and Part (Variant)
  class AssembliesPart < Spree::Base
    belongs_to :assembly, class_name: 'Spree::Product', touch: true
    belongs_to :part, class_name: 'Spree::Variant'

    acts_as_list scope: :assembly

    def self.get(assembly_id, part_id)
      find_or_initialize_by(assembly_id: assembly_id, part_id: part_id)
    end
  end
end
