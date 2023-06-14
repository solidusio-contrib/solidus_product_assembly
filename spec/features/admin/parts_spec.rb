# frozen_string_literal: true

require 'spec_helper'

describe "Parts", type: :feature, js: true do
  stub_authorization!

  let!(:tshirt) { create(:product, name: "T-Shirt") }
  let!(:mug) { create(:product, name: "Mug") }

  before do
    visit spree.admin_product_path(mug)
    check "product_can_be_part"
    click_on "Update"
  end

  it "can add and remove parts" do
    visit spree.admin_product_path(tshirt)
    click_on "Parts"
    fill_in "searchtext", with: mug.name
    click_on "Search"
    click_on "Select"
    expect(page).to have_link('Delete')

    expect(tshirt.reload.parts).to eq([mug.master])

    click_on 'Delete', wait: 30
    expect(page).not_to have_link('Delete')
    expect(tshirt.reload.parts).to eq([])
  end
end
