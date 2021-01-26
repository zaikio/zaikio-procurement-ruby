module Zaikio
  module Procurement
    class ContractRequest < Base
      uri "contract_requests(/:id)"
      include_root_in_json :contract_request

      # Associations
      belongs_to :supplier, class_name: "Zaikio::Procurement::Supplier",
                            uri: nil
    end
  end
end
