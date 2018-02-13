require 'spec_helper'

describe Spree::Product do
  before(:each) do
    @product = FactoryBot.create(:product, :name => "Foo Bar")
    @master_variant = Spree::Variant.where(is_master: true).find_by_product_id(@product.id)
  end

  describe "Spree::Product Assembly" do
    before(:each) do
      @product = create(:product)
      @part1 = create(:product, :can_be_part => true)
      @part2 = create(:product, :can_be_part => true)
      @product.add_part @part1, 1
      @product.add_part @part2, 4
    end

    it "is an assembly" do
      expect(@product).to be_assembly
    end

    it "cannot be part" do
      expect(@product).to be_assembly
      @product.can_be_part = true
      expect(@product).not_to be_valid
      expect(@product.errors[:can_be_part]).to eq ["assembly can't be part"]
    end

    it 'changing part qty changes count on_hand' do
      @product.set_part_count(@part2, 2)
      expect(@product.count_of(@part2)).to eq 2
    end
  end

  context "filter assemblies" do
    let(:mug) { create(:product) }
    let(:tshirt) { create(:product) }
    let(:product) { create(:product, can_be_part: true) }

    context "product has more than one assembly" do
      before { product.assemblies.push [mug, tshirt] }

      it "returns both products" do
        expect(product.assemblies_for([mug, tshirt])).to include mug
        expect(product.assemblies_for([mug, tshirt])).to include tshirt
      end

      it { expect(product).to be_a_part }
    end

    context "product no assembly" do
      it "returns both products" do
        expect(product.assemblies_for([mug, tshirt])).to be_empty
      end
    end
  end
end
