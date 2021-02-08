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

      def line_item_suggestions(**attributes)
        variants = attributes.delete(:variants)

        unless variants.is_a?(Array) && variants.all?(Hash)
          raise ArgumentError, "For variants, you must pass an Array of Hashes"
        end

        self.class.request(
          :post, line_item_suggestions_path, payload(attributes, variants)
        ).data.deep_symbolize_keys
      end

      private

      def payload(attributes, variants)
        MultiJson.dump(
          line_item_suggestions: {
            exclusive_sales_group_id: attributes[:exclusive_sales_group_id],
            variants: variant_payload(variants)
          }.reject { |_k, v| v.blank? }
        )
      end

      def variant_payload(variants)
        variants.collect do |variant|
          {
            id: variant[:id],
            amount: variant[:amount],
            exact_amount: variant[:exact_amount] || false,
            environmental_certification: variant[:environmental_certification],
            unit: variant[:unit] || "sheet"
          }
        end
      end

      def line_item_suggestions_path
        "suppliers/#{id}/line_item_suggestions"
      end
    end
  end
end
