module Zaikio
  module Procurement
    class Order < Base
      uri "orders(/:id)"
      include_root_in_json :order

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
