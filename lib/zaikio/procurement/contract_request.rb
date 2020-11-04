module Zaikio
  module Procurement
    class ContractRequest < Base
      uri "contract_requests(/:id)"

      # Associations
      has_one :supplier,  class_name: "Zaikio::Procurement::Supplier",
                          uri: nil
    end
  end
end
