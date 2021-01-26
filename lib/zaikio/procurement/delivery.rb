module Zaikio
  module Procurement
    class Delivery < Base
      uri "deliveries(/:id)"
      include_root_in_json :delivery

      # Associations
      belongs_to :order,             class_name: "Zaikio::Procurement::Order",
                                     uri: nil
      has_many :delivery_line_items, class_name: "Zaikio::Procurement::DeliveryLineItem",
                                     uri: "deliveries/:delivery_id/delivery_line_items(/:id)"
    end
  end
end
