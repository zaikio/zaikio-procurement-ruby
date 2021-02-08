module Zaikio
  module Procurement
    class Contract < Base
      uri "contracts(/:id)"

      # Attributes
      attributes :currency, :customer_number, :references, :consumer_id,
                 :consumer, :supplier_id, :created_at, :updated_at

      # Associations
      has_one :supplier,  class_name: "Zaikio::Procurement::Supplier",
                          uri: nil
    end
  end
end
