require_relative "concern/supplier_scoped"
module Zaikio
  module Procurement
    class Variant < Base
      include Zaikio::Procurement::SupplierScoped
      include_root_in_json :variant

      # Spyke URI override
      def self.uri
        Zaikio::Procurement.configuration.flavor == :supplier ? ":type/variants(/:id)" : "variants(/:id)"
      end

      # Attributes
      attributes :brightness, :category, :color, :dimensions_unit, :form, :grain, :height, :paper_weight,
                 :paper_weight_unit, :roughness, :thickness, :transparency, :unit_system, :whiteness,
                 :width, :article_id, :created_at, :updated_at

      # Associations
      has_one :article, class_name: "Zaikio::Procurement::Article",
                        uri: nil
      has_many :skus, class_name: "Zaikio::Procurement::Sku",
                      uri: "variants/:variant_id/skus"

      def line_item_suggestion(**attributes)
        self.class.request(
          :post, line_item_suggestions_path, payload(attributes)
        ).data.map(&:deep_symbolize_keys)
      end

      private

      def line_item_suggestions_path
        "variants/#{id}/line_item_suggestions"
      end

      def payload(attributes)
        MultiJson.dump(
          line_item_suggestion: {
            amount: attributes[:amount] || 1,
            unit: attributes[:unit],
            exact_amount: attributes[:exact_amount],
            environmental_certification: attributes[:environmental_certification],
            exclusive_sales_group_id: attributes[:exclusive_sales_group_id]
          }
        )
      end
    end
  end
end
