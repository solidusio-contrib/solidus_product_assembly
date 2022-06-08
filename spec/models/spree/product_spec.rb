# frozen_string_literal: true

require 'spec_helper'

describe Spree::Product do
  before do
    @product = FactoryBot.create(:product, name: "Foo Bar")
    @master_variant = Spree::Variant.where(is_master: true).find_by(product_id: @product.id)
  end

  describe ".search_can_be_part" do
    subject { described_class.search_can_be_part("matching") }

    let!(:name_matching_product) { create :product, can_be_part: true, name: "matching" }
    let!(:sku_matching_product) { create :product, can_be_part: true, master: variant }
    let(:variant) { create :master_variant, sku: "matching" }

    before do
      create :product, can_be_part: false, name: "matching"
      create :product, deleted_at: 1.day.ago, can_be_part: true, name: "matching"
      create :product, can_be_part: true, name: "Something else"
    end

    it "returns non-deleted products matching the search that can be parts" do
      expect(subject).to contain_exactly(name_matching_product, sku_matching_product)
    end
  end

  describe "Spree::Product Assembly" do
    before do
      @product = create(:product)
      @part1 = create(:product, can_be_part: true)
      @part2 = create(:product, can_be_part: true)
      @product.add_part @part1.master, 1
      @product.add_part @part2.master, 4
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
      @product.set_part_count(@part2.master, 2)
      expect(@product.count_of(@part2.master)).to eq 2
    end
  end
end
