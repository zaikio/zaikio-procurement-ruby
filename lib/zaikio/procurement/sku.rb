module Zaikio
  module Procurement
    class Sku < Base
      # Attributes
      attributes :amount, :amount_in_base_unit, :environmental_certification,
                 :order_number, :palletized, :unit

      # Associations
      has_many :suppliers, class_name: "Zaikio::Procurement::Supplier",
                           uri: nil
    end
  end
end
