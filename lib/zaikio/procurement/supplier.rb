module Zaikio
  module Procurement
    class Supplier < Base
      uri "suppliers(/:id)"

      # Attributes
      attributes :automatically_accept_contract_requests, :brand_color, :cancelation_policy, :display_name,
                 :slug, :supports_split_delivery, :created_at, :updated_at

      # Associations
      has_many :contract_requests, class_name: "Zaikio::Procurement::ContractRequest",
                                   uri: "suppliers/:supplier_id/contract_requests(/:id)"
    end
  end
end
