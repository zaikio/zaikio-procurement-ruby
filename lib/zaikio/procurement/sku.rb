module Zaikio
  module Procurement
    class Sku < Base
      uri "skus(/:id)"
      include_root_in_json :sku

      # Attributes
      attributes :amount, :amount_in_base_unit, :availability_in_days, :dimension_unit,
                 :environmental_certification, :gross_weight, :height, :length, :net_weight,
                 :order_number, :unit, :weight_unit, :width, :variant_id, :created_at, :updated_at

      # Associations
      has_many :prices, class_name: "Zaikio::Procurement::Price",
                        uri: "skus/:sku_id/prices"

      # Manually build variant association to work for consumers and suppliers
      def variant
        path = Zaikio::Procurement.configuration.flavor == :supplier ? "substrate/variants/#{variant_id}" : "variants/#{variant_id}"
        Zaikio::Procurement::Variant.new(self.class.request(:get, path).data)
      end
    end
  end
end
