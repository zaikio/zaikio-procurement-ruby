module Zaikio
  module Procurement
    class MaterialAvailabilityCheck < Base
      uri "material_availability_checks(/:id)"
      include_root_in_json :material_availability_check

      # Attributes
      attributes :consumer_id, :variant_id, :environmental_certification,
                 :unit, :amount, :currency, :required_at, :responded_at, :expires_at,
                 :earliest_delivery_date, :stock_availability_amount, :confirmed_price,
                 :created_at, :updated_at
    end
  end
end
