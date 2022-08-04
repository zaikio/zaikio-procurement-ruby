module Zaikio
  module Procurement
    class OrderLineItem < Base
      # Attributes
      attributes :references, :amount, :amount_in_base_unit, :base_unit, :confirmed_delivery_at, :description,
                 :order_number, :created_at, :updated_at

      # Associations
      has_one :pricing,  class_name: "Zaikio::Procurement::Pricing",
                         uri: nil
      has_one :sku,      class_name: "Zaikio::Procurement::Sku",
                         uri: nil
    end
  end
end
