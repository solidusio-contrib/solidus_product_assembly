# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Spree::Stock::SimpleCoordinator do
  describe '#shipments' do
    subject { described_class.new(order) }

    context "order shares variant as individual and within bundle" do
      include_context "product is ordered as individual and within a bundle"

      before { Spree::StockItem.update_all(count_on_hand: 10) }

      context "bundle part requires more units than individual product" do
        before { order.contents.add(bundle_variant, 5) }

        it "includes inventory units for all bundle parts" do
          variant_ids = subject.shipments.flat_map(&:inventory_units).map(&:variant_id)
          expect(variant_ids).to contain_exactly(*bundle.parts.map(&:id))
        end
      end
    end

    context "multiple stock locations" do
      let!(:stock_locations) { (1..3).map { create(:stock_location) } }
      let(:order) { create(:order_with_line_items) }
      let(:parts) { (1..3).map { create(:variant) } }
      let(:bundle_variant) { order.variants.first }
      let(:bundle) { bundle_variant.product }

      before { bundle.parts << parts }

      it "includes inventory units for all bundle parts" do
        variant_ids = subject.shipments.flat_map(&:inventory_units).map(&:variant_id)
        expect(variant_ids).to contain_exactly(*bundle.parts.map(&:id))
      end
    end
  end
end
