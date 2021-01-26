module Zaikio
  module Procurement
    class DeliveryLineItem < Base
      uri "delivery_line_items(/:id)"
      include_root_in_json :delivery_line_item

      # Associations
      belongs_to :delivery,     class_name: "Zaikio::Procurement::Delivery",
                                uri: nil
      has_one :order_line_item, class_name: "Zaikio::Procurement::OrderLineItem",
                                uri: nil
    end
  end
end
