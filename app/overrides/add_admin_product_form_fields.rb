# frozen_string_literal: true

Deface::Override.new(
  virtual_path: "spree/admin/products/_form",
  name: "product_assembly_admin_product_form_right",
  insert_bottom: "[data-hook='admin_product_form_right']",
  partial: "spree/admin/products/product_assembly_fields",
  disabled: false,
)
