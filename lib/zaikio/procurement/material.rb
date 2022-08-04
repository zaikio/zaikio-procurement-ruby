module Zaikio
  module Procurement
    class Material < Base
      attributes :amount,
                 :description,
                 :environmental_certification,
                 :unit,
                 :sku_preference_ids

      # Associations
      has_one :supplier, class_name: "Zaikio::Procurement::Supplier", uri: nil
      has_one :variant, class_name: "Zaikio::Procurement::Variant", uri: nil
    end
  end
end
