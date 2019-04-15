require 'spec_helper'

describe "Return Items", type: :feature, js: true do
  stub_authorization!

  let(:order) { create(:order_with_line_items) }
  let(:line_item) { order.line_items.first }

  context 'when the order product is a bundle' do
    let(:bundle) { line_item.product }
    let(:parts) { (1..3).map { create(:variant) } }

    before do
      bundle.parts << [parts]
      order.reload.create_proposed_shipments
      order.finalize!
      order.update state: :complete
      order.shipments.update_all state: :shipped
    end

    it 'builds one return item for each part, splitting the bundle price on them' do
      visit spree.edit_admin_order_path(order)
      expect(page).to have_selector '.line-item-total', text: '$10.00'
      click_link 'RMA'
      click_link 'New RMA'
      expect(page).to have_selector '.return-item-pre-tax-refund-amount', text: '$3.33', count: 3
    end
  end

  context 'when the product is not a bundle' do
    before do
      order.reload.create_proposed_shipments
      order.finalize!
      order.update state: :complete
      order.shipments.update_all state: :shipped
    end

    it 'builds one return item for each product' do
      visit spree.edit_admin_order_path(order)
      expect(page).to have_selector '.item-total', text: '$10.00'
      click_link 'RMA'
      click_link 'New RMA'
      expect(page).to have_selector '.return-item-pre-tax-refund-amount', text: '$10.00', count: 1
    end
  end
end
