module Zaikio
  module Procurement
    class Contract < Base
      uri "contracts(/:id)"
      include_root_in_json :contract

      # Attributes
      attributes :currency, :customer_number, :references, :consumer_id,
                 :consumer, :supplier_id, :created_at, :updated_at

      # Associations
      has_one :supplier,  class_name: "Zaikio::Procurement::Supplier",
                          uri: nil
      has_one :contract_request, uri: nil
    end
  end
end
