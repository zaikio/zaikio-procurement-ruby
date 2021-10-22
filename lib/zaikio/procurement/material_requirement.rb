module Zaikio
  module Procurement
    class MaterialRequirement < Base
      uri "material_requirements(/:id)"
      include_root_in_json :material_requirement

      # Attributes
      attributes :amount, :anticipated_costs, :archived_at, :archived_by, :article_category, :canceled_at, :currency,
                 :description, :environmental_certification, :expected_at, :fulfilled_at, :material_required_at,
                 :job_client, :job_description, :job_link, :job_reference, :ordered_at, :order_number, :person,
                 :price, :purchaser, :price_based_on_quantity, :processed_at, :references, :site, :state, :unit,
                 :created_at, :updated_at

      # Associations
      has_one :supplier, class_name: "Zaikio::Procurement::Supplier", uri: nil
      has_one :variant, class_name: "Zaikio::Procurement::Variant", uri: nil
      has_many :order_line_items, class_name: "Zaikio::Procurement::OrderLineItem", uri: nil

      def order(purchaser_id:)
        result = self.class.request(:post, "material_requirements/#{id}/order",
                                    order: { purchaser_id: purchaser_id })

        Zaikio::Procurement::MaterialRequirement.new(result.data)
      end
    end
  end
end
