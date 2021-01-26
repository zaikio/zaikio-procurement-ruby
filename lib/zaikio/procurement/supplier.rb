module Zaikio
  module Procurement
    class Supplier < Base
      uri "suppliers(/:id)"

      # Associations
      has_many :contract_requests, class_name: "Zaikio::Procurement::ContractRequest",
                                   uri: "suppliers/:supplier_id/contract_requests(/:id)"
    end
  end
end
