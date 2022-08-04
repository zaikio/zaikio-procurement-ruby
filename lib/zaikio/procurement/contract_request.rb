module Zaikio
  module Procurement
    class ContractRequest < Base
      uri "contract_requests(/:id)"
      include_root_in_json :contract_request

      def self.create(supplier_id:, **attributes)
        new(request(:post, "suppliers/#{supplier_id}/contract_requests",
                    contract_request: attributes)&.body&.dig("data"))
      end

      # Attributes
      attributes :contact_email, :contact_first_name, :contact_last_name,
                 :contact_phone, :customer_number, :declined_at, :declined_reason,
                 :references, :state, :created_at, :updated_at

      # Associations
      belongs_to :supplier, class_name: "Zaikio::Procurement::Supplier",
                            uri: nil
    end
  end
end
