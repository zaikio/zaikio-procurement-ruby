module Zaikio
  module Procurement
    class Contract < Base
      uri "contracts(/:id)"

      # Associations
      has_one :supplier,  class_name: "Zaikio::Procurement::Supplier",
                          uri: nil
    end
  end
end
