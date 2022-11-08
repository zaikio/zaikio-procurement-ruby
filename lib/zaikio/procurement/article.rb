module Zaikio
  module Procurement
    class Article < Base
      # Attributes
      attributes :base_unit, :description, :manufacturer, :name,
                 :summary, :classification_reports, :certifications,
                 :coated, :finish, :kind

      # Associations
      has_one :supplier, class_name: "Zaikio::Procurement::Supplier",
                         uri: nil
      has_many :skus,    class_name: "Zaikio::Procurement::Sku",
                         uri: nil
    end
  end
end
