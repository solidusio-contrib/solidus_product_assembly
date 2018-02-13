Spree::Product.class_eval do
  has_and_belongs_to_many  :parts, :class_name => "Spree::Product",
        :join_table => "spree_assemblies_parts",
        :foreign_key => "assembly_id", :association_foreign_key => "part_id"

  has_many :assemblies_parts, :class_name => "Spree::AssembliesPart",
    :foreign_key => "assembly_id"

  scope :individual_saled, -> { where(individual_sale: true) }

  scope :search_can_be_part, ->(query){ not_deleted.available.joins(:master)
    .where(arel_table["name"].matches("%#{query}%").or(Spree::Variant.arel_table["sku"].matches("%#{query}%")))
    .where(can_be_part: true)
    .limit(30)
  }

  validate :assembly_cannot_be_part, :if => :assembly?

  has_and_belongs_to_many  :assemblies, :class_name => "Spree::Product",
        :join_table => "spree_assemblies_parts",
        :foreign_key => "part_id", :association_foreign_key => "assembly_id"

  def assemblies_for(products)
    assemblies.where(id: products)
  end

  def part?
    assemblies.exists?
  end

  def add_part(product, count = 1)
    set_part_count(product, count_of(product) + count)
  end

  def remove_part(product)
    set_part_count(product, 0)
  end

  def set_part_count(product, count)
    ap = assemblies_part(product)
    if count > 0
      ap.count = count
      ap.save
    else
      ap.destroy
    end
    reload
  end

  def assembly?
    parts.present?
  end

  def count_of(product)
    ap = assemblies_part(product)
    # This checks persisted because the default count is 1
    ap.persisted? ? ap.count : 0
  end

  def assembly_cannot_be_part
    errors.add(:can_be_part, Spree.t(:assembly_cannot_be_part)) if can_be_part
  end

  private
  def assemblies_part(product)
    Spree::AssembliesPart.get(self.id, product.id)
  end
end
