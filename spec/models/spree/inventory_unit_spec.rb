# frozen_string_literal: true

require 'spec_helper'

module Spree
  describe InventoryUnit do
    subject { described_class.create!(attributes) }

    let!(:order) { create(:order_with_line_items) }
    let(:line_item) { order.line_items.first }
    let(:product) { line_item.product }
    let(:shipment) { create(:shipment, order: order) }

    if Spree.solidus_gem_version < Gem::Version.new('2.5.x')
      let(:attributes) { { shipment: shipment, line_item: line_item, variant: line_item.variant, order: order } }
    else
      let(:attributes) { { shipment: shipment, line_item: line_item, variant: line_item.variant } }
    end

    context 'if the unit is not part of an assembly' do
      it 'returns the percentage of a line item' do
        expect(subject.percentage_of_line_item).to eql(BigDecimal(1))
      end
    end

    context 'if part of an assembly' do
      let(:parts) { (1..2).map { create(:variant) } }

      before do
        product.parts << parts
        order.create_proposed_shipments
      end

      it 'returns the percentage of a line item' do
        subject.line_item = line_item
        expect(subject.percentage_of_line_item).to eql(BigDecimal(0.5, 2))
      end
    end
  end
end
