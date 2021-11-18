module Zaikio
  module Procurement
    class OrderConditionsInquiry < Base
      uri "order_conditions_inquiries(/:id)"
      include_root_in_json :order_conditions_inquiry

      # Attributes
      attributes :contract_id, :currency, :created_at, :updated_at,
                 :desired_delivery_date, :verified_at, :expires_at,
                 :verified_net_handling_fee, :verified_net_shipping_fee,
                 :verified_net_total, :verified_delivery_date, :order_line_items,
                 :verified_order_line_items
    end
  end
end
