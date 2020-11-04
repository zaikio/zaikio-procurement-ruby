module Zaikio
  module Procurement
    class Price < Base
      uri "prices(/:id)"

      # Associations
      has_one :sku, class_name: "Zaikio::Procurement::Sku",
                    uri: nil
    end
  end
end
