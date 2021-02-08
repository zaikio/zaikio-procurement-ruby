module Zaikio
  module Procurement
    class ContractRequest < Base
      uri "contract_requests(/:id)"
      include_root_in_json :contract_request

      # Attributes
      attributes :accepted_at, :connectivity_checked_at, :contact_email, :contact_first_name,
                 :contact_last_name, :contact_phone, :currency, :customer_number, :declined_at,
                 :mapped_at, :references, :state, :vetted_at, :consumer_id, :consumer, :supplier_id,
                 :created_at, :updated_at

      # Associations
      belongs_to :supplier, class_name: "Zaikio::Procurement::Supplier",
                            uri: nil
    end
  end
end
