Spree::ReturnItem.class_eval do
  self.refund_amount_calculator = Spree::Calculator::Returns::AssembliesDefaultRefundAmount
end
