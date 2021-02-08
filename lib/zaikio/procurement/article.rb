module Zaikio
  module Procurement
    class Article < Base
      uri "articles(/:id)"

      # Attributes
      attributes :name, :base_unit, :coated, :description, :finish,
                 :kind, :supplier_id, :created_at, :updated_at

      # Class methods
      class << self
        def list_by_article_type_or_supplier_slug(type_or_slug)
          with("#{type_or_slug}/articles").get
        end

        def list_by_article_type_and_supplier_slug(type, slug)
          with("#{type}/#{slug}/articles").get
        end
      end

      # Associations
      has_one :supplier,  class_name: "Zaikio::Procurement::Supplier",
                          uri: nil
      has_many :variants, class_name: "Zaikio::Procurement::Variant",
                          uri: "articles/:article_id/variants"
    end
  end
end
