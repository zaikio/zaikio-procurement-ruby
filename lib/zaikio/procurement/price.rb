module Zaikio
  module Procurement
    class Price < Base
      uri "prices(/:id)"

      # Attributes
      attributes :kind, :minimum_order_quantity, :order_number, :price, :valid_from,
                 :valid_until, :sales_group_id, :sku_id, :created_at, :updated_at

      # Associations
      has_one :sku,         class_name: "Zaikio::Procurement::Sku",
                            uri: nil
      has_one :sales_group, class_name: "Zaikio::Procurement::SalesGroup",
                            uri: nil
    end
  end
end
