module Zaikio
  module Procurement
    class Variant < Base
      include_root_in_json :variant

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
