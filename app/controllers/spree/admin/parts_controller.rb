# frozen_string_literal: true

class Spree::Admin::PartsController < Spree::Admin::BaseController
  before_action :find_product

  def index
    @assembly_parts = @product
      .assemblies_parts
      .joins(:part)
      .where(spree_variants: { deleted_at: nil })
      .includes(part: :product)
  end

  def remove
    @part = Spree::Variant.find(params[:id])
    @product.remove_part(@part)
    render 'spree/admin/parts/update_parts_table'
  end

  def set_count
    @part = Spree::Variant.find(params[:id])
    @product.set_part_count(@part, params[:count].to_i)
    render 'spree/admin/parts/update_parts_table'
  end

  def available
    @available_products =
      if params[:q].blank?
        []
      else
        Spree::Product.search_can_be_part("%#{params[:q]}%").distinct
      end

    respond_to do |format|
      format.html { render layout: false }
      format.js { render layout: false }
    end
  end

  def create
    @part = Spree::Variant.find(params[:part_id])
    qty = params[:part_count].to_i
    @product.add_part(@part, qty) if qty > 0
    render 'spree/admin/parts/update_parts_table'
  end

  private

  def find_product
    @product = Spree::Product.find_by(slug: params[:product_id])
  end

  def model_class
    Spree::AssembliesPart
  end
end
