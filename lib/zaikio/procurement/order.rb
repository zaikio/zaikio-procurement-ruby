module Zaikio
  module Procurement
    class Order < Base
      uri "orders(/:id)"
      include_root_in_json :order

      # Attributes
      attributes :copy_material_requirement_references_to_line_items, :currency, :references,
                 :state, :canceled_by_consumer_at, :canceled_by_supplier_at, :confirmed_at,
                 :placed_at, :transferred_at, :created_at, :updated_at

      # Associations
      has_one :delivery,          class_name: "Zaikio::Procurement::Delivery",
                                  uri: nil
      has_many :order_line_items, class_name: "Zaikio::Procurement::OrderLineItem",
                                  uri: nil
      has_one :pricing,           class_name: "Zaikio::Procurement::Pricing",
                                  uri: nil
      has_one :person,            class_name: "Zaikio::Procurement::Person",
                                  uri: nil

      def place
        Zaikio::Procurement::MaterialRequirement.new(
          self.class.request(:patch, "orders/#{id}/place").data
        )
      end

      def cancel
        Zaikio::Procurement::MaterialRequirement.new(
          self.class.request(:patch, "orders/#{id}/cancel").data
        )
      end
    end
  end
end
