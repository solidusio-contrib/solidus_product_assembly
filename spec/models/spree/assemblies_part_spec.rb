# frozen_string_literal: true

require 'spec_helper'

module Spree
  describe AssembliesPart do
    let(:product) { create(:product) }
    let(:variant) { create(:variant) }

    before do
      product.parts.push variant
    end

    context "get" do
      it "brings part by product and variant id" do
        expect(subject.class.get(product.id, variant.id).part).to eq variant
      end
    end
  end
end
