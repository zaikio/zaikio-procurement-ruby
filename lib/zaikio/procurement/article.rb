module Zaikio
  module Procurement
    class Article < Base
      include_root_in_json :article

      # Class methods
      class << self
        # Spyke URI override
        def uri
          Zaikio::Procurement.configuration.flavor == :supplier ? "substrate/articles(/:id)" : "articles(/:id)"
        end

        def list_by_article_type_or_supplier_slug(type_or_slug)
          with("#{type_or_slug}/articles").get
        end

        def list_by_article_type_and_supplier_slug(type, slug)
          with("#{type}/#{slug}/articles").get
        end
      end

      # Attributes
      attributes :name, :base_unit, :coated, :description, :finish,
                 :kind, :supplier_id, :created_at, :updated_at

      # Associations
      has_one :supplier,  class_name: "Zaikio::Procurement::Supplier",
                          uri: nil
      # Manually build variants association to work for consumers and suppliers
      def variants
        self.class.request(:get, "#{uri}/variants").data.collect { |v| Zaikio::Procurement::Variant.new(v) }
      end
    end
  end
end
