require 'spec_helper'

describe "Return Items", type: :feature, js: true do
  stub_authorization!

  let(:order) { create(:order_with_line_items) }
  let(:line_item) { order.line_items.first }

  context 'when the order product is a bundle' do
    let(:bundle) { line_item.product }
    let(:parts) { (1..3).map { create(:variant) } }

    before do
      create :refund_reason, name: Spree::RefundReason::RETURN_PROCESSING_REASON, mutable: false
      bundle.parts << [parts]
      parts.each { |p| p.stock_items.first.set_count_on_hand 4 }
      3.times { order.next }
      create :payment, order: order, amount: order.amount
      order.next
      order.complete
      order.payments.each(&:capture!)
      order.shipments.each { |s| s.update state: :ready }
      order.shipments.each(&:ship!)
    end

    it 'successfully generates a RMA, a reimbursement and a refund' do
      visit spree.edit_admin_order_path(order)
      expect(page).to have_selector '.line-item-total', text: '$10.00'
      click_link 'RMA'
      click_link 'New RMA'

      expect(page).to have_selector '.return-item-charged', text: '$3.33', count: 3
      find('#select-all').click
      select Spree::StockLocation.first.name, from: 'Stock Location'

      click_button 'Create'

      expect(page).to have_content 'Return Authorization has been successfully created!'
      click_link 'Customer Returns'
      click_link 'New Customer Return'
      find('#select-all').click
      page.execute_script %{$('option[value="receive"]').attr('selected', 'selected')}
      select Spree::StockLocation.first.name, from: 'Stock Location'

      click_button 'Create'

      expect(page).to have_content 'Customer Return has been successfully created!'
      click_button 'Create reimbursement'

      click_button 'Reimburse'

      within 'table.reimbursement-refunds' do
        expect(page).to have_content '$10.00'
      end
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
