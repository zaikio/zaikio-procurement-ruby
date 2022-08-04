module Zaikio
  module Procurement
    class Article < Base
      # Associations
      has_one :supplier, class_name: "Zaikio::Procurement::Supplier",
                         uri: nil
      has_many :skus,    class_name: "Zaikio::Procurement::Sku",
                         uri: nil
    end
  end
end
