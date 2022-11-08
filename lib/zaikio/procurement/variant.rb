module Zaikio
  module Procurement
    class Variant < Base
      include_root_in_json :variant

      # Constants
      def self.types
        %w[carbonless_copy_paper coating coating_plate envelope ink laminating_foil
           offset_printing_blanket plate ring_binding self_adhesive sheet_substrate
           sleeking_foil specialized_printing_blanket web_substrate].freeze
      end

      # Attributes
      attributes :type, :summary, :global_trade_item_number, :brightness, :category, :color,
                 :dimensions_unit, :form, :grain, :height, :optical_brightness_agent,
                 :optical_brightness_agent_amount, :paper_weight, :paper_weight_unit, :roughness,
                 :thickness, :transparency, :white_point_m0, :white_point_m1, :whiteness, :width

      # Associations
      has_one :article, class_name: "Zaikio::Procurement::Article",
                        uri: nil
      has_many :skus,   class_name: "Zaikio::Procurement::Sku",
                        uri: nil
    end
  end
end
