# frozen_string_literal: true

require 'spec_helper'

module Spree
  describe OrderInventoryAssembly do
    subject { described_class.new(line_item) }

    let(:order) { create(:order_with_line_items) }
    let(:line_item) { order.line_items.first }
    let(:bundle) { line_item.product }
    let(:parts) { (1..3).map { create(:variant) } }

    before do
      bundle.parts << [parts]
      bundle.set_part_count(parts.first, 3)

      line_item.update!(quantity: 3)
      order.reload.create_proposed_shipments
      allow(order).to receive(:completed?).and_return(true)
    end

    context "inventory units count" do
      it "calculates the proper value for the bundle" do
        expected_units_count = line_item.quantity * bundle.assemblies_parts.to_a.sum(&:count)
        expect(subject.inventory_units.count).to eql(expected_units_count)
      end
    end

    context "verify line item units" do
      let!(:original_units_count) { subject.inventory_units.count }

      context "quantity increases" do
        before { subject.line_item.quantity += 1 }

        it "inserts new inventory units for every bundle part" do
          expected_units_count = original_units_count + bundle.assemblies_parts.to_a.sum(&:count)
          subject.verify

          # needs to reload so that inventory units are fetched from the updated order.shipments
          updated_units_count = described_class.new(line_item.reload).inventory_units.count
          expect(updated_units_count).to eql(expected_units_count)
        end
      end

      context "quantity decreases" do
        before { subject.line_item.quantity -= 1 }

        it "remove inventory units for every bundle part" do
          expected_units_count = original_units_count - bundle.assemblies_parts.to_a.sum(&:count)
          subject.verify

          # needs to reload so that inventory units are fetched from the updated order.shipments
          updated_units_count = described_class.new(line_item.reload).inventory_units.count
          expect(updated_units_count).to eql(expected_units_count)
        end
      end
    end
  end
end
