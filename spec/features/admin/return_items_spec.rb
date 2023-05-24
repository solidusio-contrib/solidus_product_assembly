# frozen_string_literal: true

require 'spec_helper'

describe "Return Items", type: :feature, js: true do
  stub_authorization!

  let(:line_item) { order.line_items.first }

  before do
    allow_any_instance_of(Spree::Admin::ReimbursementsController).to receive(:try_spree_current_user) { Spree.user_class.new }
  end

  context 'when the order product is a bundle' do
    let(:bundle) { line_item.product }
    let(:parts) { (1..3).map { create(:variant) } }

    before do
      create :refund_reason, name: Spree::RefundReason::RETURN_PROCESSING_REASON, mutable: false
      bundle.parts << [parts]
      bundle.set_part_count(parts.first, 2)
      parts.each { |p| p.stock_items.first.set_count_on_hand 4 }
      3.times { order.next }
      create :payment, order: order, amount: order.amount
      order.next
      order.complete!
      order.payments.each(&:capture!)
      order.shipments.each { |s| s.update state: :ready }
      order.shipments.each(&:ship!)
    end

    context 'with a single item cart' do
      let(:order) { create(:order_with_line_items) }

      it 'successfully generates a RMA, a reimbursement and a refund' do
        visit spree.edit_admin_order_path(order)

        expect(page).to have_selector '.line-item-total', text: '$10.00'

        click_link 'RMA'
        click_link 'New RMA'

        expect(page).to have_selector '.return-item-charged', text: '$2.50', count: 4

        find('#select-all').click
        select Spree::StockLocation.first.name, from: 'Stock Location'
        click_button 'Create'

        expect(page).to have_content 'Return Authorization has been successfully created!'

        click_link 'Customer Returns'
        click_link 'New Customer Return'
        find('#select-all').click
        page.execute_script <<~JS
          $('option[value="receive"]').attr('selected', 'selected');
        JS
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

    context 'with a multiple items cart' do
      let(:order) { create(:order_with_line_items, line_items_attributes: [{ quantity: 2 }]) }

      it 'successfully generates a RMA, a reimbursement and a refund' do
        visit spree.edit_admin_order_path(order)

        expect(page).to have_selector '.line-item-total', text: '$20.00'

        click_link 'RMA'
        click_link 'New RMA'

        expect(page).to have_selector '.return-item-charged', text: '$2.50', count: 8

        find('#select-all').click
        select Spree::StockLocation.first.name, from: 'Stock Location'
        click_button 'Create'

        expect(page).to have_content 'Return Authorization has been successfully created!'

        click_link 'Customer Returns'
        click_link 'New Customer Return'
        find('#select-all').click
        page.execute_script <<~JS
          $('option[value="receive"]').attr('selected', 'selected');
        JS
        select Spree::StockLocation.first.name, from: 'Stock Location'
        click_button 'Create'

        expect(page).to have_content 'Customer Return has been successfully created!'

        click_button 'Create reimbursement'
        click_button 'Reimburse'

        within 'table.reimbursement-refunds' do
          expect(page).to have_content '$20.00'
        end
      end
    end
  end

  context 'when the product is not a bundle' do
    before do
      create :refund_reason, name: Spree::RefundReason::RETURN_PROCESSING_REASON, mutable: false
      order.line_items.each { |li| li.variant.stock_items.first.set_count_on_hand 4 }
      3.times { order.next }
      create :payment, order: order, amount: order.amount
      order.next
      order.complete!
      order.payments.each(&:capture!)
      order.shipments.each { |s| s.update state: :ready }
      order.shipments.each(&:ship!)
    end

    context 'with a single item cart' do
      let(:order) { create(:order_with_line_items) }

      it 'builds one return item for each product' do
        visit spree.edit_admin_order_path(order)

        expect(page).to have_selector '.item-total', text: '$10.00'

        click_link 'RMA'
        click_link 'New RMA'

        within '.return-items-table tbody' do
          expect(page).to have_selector 'tr', count: 1
          expect(page).to have_selector :field, class: 'refund-amount-input', with: '10.0', count: 1
        end
      end
    end

    context 'with a multiple items cart' do
      let(:order) { create(:order_with_line_items, line_items_attributes: [{ quantity: 2 }]) }

      it 'builds one return item for each product' do
        visit spree.edit_admin_order_path(order)

        expect(page).to have_selector '.item-total', text: '$20.00'

        click_link 'RMA'
        click_link 'New RMA'

        within '.return-items-table tbody' do
          expect(page).to have_selector 'tr', count: 2
          expect(page).to have_selector :field, class: 'refund-amount-input', with: '10.0', count: 2
        end
      end
    end
  end
end
