# frozen_string_literal: true

shared_context "product is ordered as individual and within a bundle" do
  let!(:order) { create(:order_with_line_items, line_items_attributes: [{ product: bundle }]) }
  let(:parts) { create_list(:variant, 3) }
  let(:bundle) { create :product, parts: }
  let(:bundle_variant) { bundle.master }
  let(:common_product) { order.variants.last }
end
