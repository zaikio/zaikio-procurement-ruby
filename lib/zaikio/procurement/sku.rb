module Zaikio
  module Procurement
    class Sku < Base
      uri "skus(/:id)"

      # Associations
      has_one :variant, class_name: "Zaikio::Procurement::Variant",
                        uri: nil
      has_many :prices, class_name: "Zaikio::Procurement::Price",
                        uri: "skus/:sku_id/prices"
    end
  end
end
