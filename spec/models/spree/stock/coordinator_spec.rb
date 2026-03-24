# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Spree::Stock::SimpleCoordinator do
  include_context "product is ordered as individual and within a bundle"

  describe '#shipments' do
    subject { described_class.new(order) }

    context "when ordering many of the same bundle" do
      before { Spree::StockItem.update_all(count_on_hand: 10) }

      context "when purchasing many of the same bundle" do
        before { order.contents.add(bundle_variant, 5) }

        it "includes inventory units for all bundle parts" do
          variant_ids = subject.shipments.flat_map(&:inventory_units).map(&:variant_id)
          expect(variant_ids).to contain_exactly(*bundle.parts.map(&:id)*6)
        end
      end
    end

    context "when the parts are split across multiple stock locations" do
      include_context "product is ordered as individual and within a bundle"

      # Make sure the stock items for each part are in different stock
      # locations, otherwise the coordinator will just pull from one location
      # and not test the behavior we want to test.
      before do
        create :stock_location
        Spree::StockItem.destroy_all

        Spree::StockLocation.all.each_with_index do |stock_location, index|
          Spree::StockItem.create!(
            stock_location:,
            variant: bundle.parts[index]
          ).set_count_on_hand(10)
        end
      end

      it "includes inventory units for all bundle parts" do
        variant_ids = subject.shipments.flat_map(&:inventory_units).map(&:variant_id)
        expect(variant_ids).to contain_exactly(*bundle.parts.map(&:id))
      end
    end
  end
end
