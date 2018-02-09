Spree::Stock::AvailabilityValidator.class_eval do
  prepend Spree::Stock::AssemblyAvailabilityValidator
end
