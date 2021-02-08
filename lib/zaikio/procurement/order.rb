module Zaikio
  module Procurement
    class Order < Base
      uri "orders(/:id)"
      include_root_in_json :order

      # Attributes
      attributes :canceled_by_consumer_at, :canceled_by_supplier_at, :cancelation_requested_at, :confirmed_at,
                 :currency, :delivery_mode, :gross_total, :net_handling_fee, :net_shipping_fee, :net_total,
                 :partially_shipped_at, :partially_shipped_remainder_canceled_at, :placed_at, :producing_at,
                 :references, :shipped_at, :state, :state_reason, :taxes, :taxes_on_fees, :transfer_failed_at,
                 :transferred_at, :contract_id, :exclusive_sales_group_id, :person_id, :created_at, :updated_at

      # Associations
      has_one :contract,              class_name: "Zaikio::Procurement::Contract",
                                      uri: "contracts(/:id)"
      has_one :exclusive_sales_group, class_name: "Zaikio::Procurement::SalesGroup",
                                      uri: "sales_groups(/:id)"
      has_many :order_line_items,     class_name: "Zaikio::Procurement::OrderLineItem",
                                      uri: "orders/:order_id/order_line_items(/:id)"
      has_many :deliveries,           class_name: "Zaikio::Procurement::Delivery",
                                      uri: "orders/:order_id/deliveries(/:id)"
    end
  end
end
