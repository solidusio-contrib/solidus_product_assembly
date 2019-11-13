# frozen_string_literal: true

require 'spec_helper'

module Spree
  module Stock
    describe AvailabilityValidator, type: :model do
      context "line item has no parts" do
        subject { described_class.new }

        let!(:line_item) { create(:line_item, quantity: 5) }
        let!(:product) { line_item.product }

        it 'delegates to the original Solidus implementation' do
          expect(subject).to receive(:is_valid?).with(line_item)
          subject.validate(line_item)
        end
      end

      context "line item has parts" do
        subject { described_class.new }

        let!(:order) { create(:order_with_line_items) }
        let(:line_item) { order.line_items.first }
        let(:product) { line_item.product }
        let(:variant) { line_item.variant }
        let(:parts) { (1..2).map { create(:variant) } }

        before { product.parts << parts }

        it 'is valid when supply of all parts is sufficient' do
          allow_any_instance_of(Stock::Quantifier).to receive(:can_supply?).and_return(true)
          expect(line_item).not_to receive(:errors)
          subject.validate(line_item)
        end

        it 'is invalid when supplies of all parts are insufficent' do
          allow_any_instance_of(Stock::Quantifier).to receive(:can_supply?).and_return(false)
          expect(line_item.errors).to receive(:[]).exactly(line_item.parts.size).times.with(:quantity).and_return([])
          subject.validate(line_item)
        end

        it 'is invalid when supply of 1 part is insufficient' do
          allow_any_instance_of(Stock::Quantifier).to receive(:can_supply?).and_return(false)
          create_list(:inventory_unit, 5, line_item: line_item, variant: line_item.parts.first, order: order, shipment: order.shipments.first)
          expect(line_item.errors).to receive(:[]).once.with(:quantity).and_return([])
          subject.validate(line_item)
        end

        it 'is valid when supply of each part is sufficient' do
          line_item.parts.each do |part|
            allow(part).to receive(:inventory_units).and_return([double(variant: part)] * 5)
          end
          expect(line_item).not_to receive(:errors)
          subject.validate(line_item)
        end
      end
    end
  end
end
