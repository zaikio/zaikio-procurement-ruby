module Zaikio
  module Procurement
    class OrderLineItem < Base
      uri "order_line_items(/:id)"
      include_root_in_json :order_line_item

      # Attributes
      attributes :amount, :amount_in_base_unit, :base_unit, :catalog_price, :confirmed_price, :description,
                 :order_number, :tax_rate, :taxes, :total_gross_price, :total_net_price, :unit, :order_id,
                 :sku_id, :created_at, :updated_at

      # Associations
      belongs_to :order, class_name: "Zaikio::Procurement::Order",
                         uri: nil
      has_one :sku,      class_name: "Zaikio::Procurement::Sku",
                         uri: nil
    end
  end
end
