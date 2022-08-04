module Zaikio
  module Procurement
    class MaterialRequirement < Base
      uri "material_requirements(/:id)"
      include_root_in_json :material_requirement

      # Attributes
      attributes :state, :references, :visible_in_web, :ordered_at, :fulfilled_at, :canceled_at, :created_at,
                 :updated_at

      # Associations
      has_one :required_material, class_name: "Zaikio::Procurement::Material", uri: nil
      has_one :delivery, class_name: "Zaikio::Procurement::Delivery", uri: nil
      has_one :order, class_name: "Zaikio::Procurement::Order", uri: nil
      has_one :pricing, class_name: "Zaikio::Procurement::Pricing", uri: nil
      has_one :availability, class_name: "Zaikio::Procurement::Availability", uri: nil
      has_one :quantity, class_name: "Zaikio::Procurement::Quantity", uri: nil
      has_one :job, class_name: "Zaikio::Procurement::Job", uri: nil
      has_one :creator, class_name: "Zaikio::Procurement::Person", uri: nil

      def archive
        Zaikio::Procurement::MaterialRequirement.new(
          self.class.request(:patch, "#{collection_name}/#{id}/archive").data
        )
      end

      def refresh
        Zaikio::Procurement::MaterialRequirement.new(
          self.class.request(:patch, "#{collection_name}/#{id}/refresh").data
        )
      end

      private

      def collection_name
        self.class.name.demodulize.underscore.pluralize
      end
    end
  end
end
