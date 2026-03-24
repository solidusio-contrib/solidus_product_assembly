# frozen_string_literal: true

require 'spec_helper'

module Spree
  module Stock
    describe InventoryUnitBuilder, type: :model do
      subject { described_class.new(order) }

      context "order shares variant as individual and within bundle" do
        include_context "product is ordered as individual and within a bundle" do
          describe "#units" do
            it "returns an inventory unit for each part of each quantity for the order's line items" do
              units = subject.units
              expect(units.count).to eq 3
              expect(units[0].line_item.quantity).to eq 1

              line_item = order.line_items.sole

              expect(units.map(&:variant)).to match_array line_item.parts
            end

            it "builds the inventory units as pending" do
              expect(subject.units.map(&:pending).uniq).to eq [true]
            end
          end
        end
      end
    end
  end
end
