module Zaikio
  module Procurement
    class Variant < Base
      uri "variants(/:id)"

      # Associations
      has_one :article, class_name: "Zaikio::Procurement::Article",
                        uri: nil
      has_many :skus,   class_name: "Zaikio::Procurement::Sku",
                        uri: "variants/:variant_id/skus"
    end
  end
end
