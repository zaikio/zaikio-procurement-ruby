module Zaikio
  module Procurement
    class Sku < Base
      # Associations
      has_many :suppliers, class_name: "Zaikio::Procurement::Supplier",
                           uri: nil
    end
  end
end
