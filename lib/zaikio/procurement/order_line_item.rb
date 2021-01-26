module Zaikio
  module Procurement
    class OrderLineItem < Base
      uri "order_line_items(/:id)"
      include_root_in_json :order_line_item

      # Associations
      belongs_to :order, class_name: "Zaikio::Procurement::Order",
                         uri: nil
      has_one :sku,      class_name: "Zaikio::Procurement::Sku",
                         uri: nil
    end
  end
end
