# frozen_string_literal: true

describe Spree::OrderContents do
  subject(:contents) { described_class.new(order) }

  let(:store) { create :store }
  let(:order) { create :order, store: store }

  let(:guitar) { create(:variant) }
  let(:bass) { create(:variant) }

  let(:bundle) { create(:product) }

  before { bundle.parts.push [guitar, bass] }

  context "same variant within bundle and as regular product" do
    let!(:guitar_item) { contents.add(guitar, 3) }
    let!(:bundle_item) { contents.add(bundle.master, 5) }

    it "destroys the variant as regular product only" do
      contents.remove(guitar, 3)
      expect(order.reload.line_items.to_a).to eq [bundle_item]
    end

    context "completed order" do
      before do
        order.create_proposed_shipments
        order.touch :completed_at
      end

      it "destroys accurate number of inventory units" do
        expect do
          contents.remove(guitar, 3)
        end.to change(Spree::InventoryUnit, :count).by(-3)
      end
    end
  end
end
