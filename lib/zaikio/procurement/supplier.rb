module Zaikio
  module Procurement
    class Supplier < Base
      uri "suppliers(/:id)"

      def self.upcoming
        result = Zaikio::Procurement::Supplier
                 .request(:get, "upcoming_suppliers")&.body&.dig("data")

        result.collect { |s| Zaikio::Procurement::Supplier.new(s) }
      end

      # Attributes
      attributes :slug, :name, :connected, :currency, :customer_number, :prices_updated_at,
                 :additional_pricing_agreements, :article_types, :automatically_accept_contract_requests,
                 :brand_color, :cancelation_policy, :logo_url, :maximum_days_until_delivery,
                 :minimum_days_before_delivery, :supports_split_delivery, :maximum_order_size, :created_at, :updated_at
    end
  end
end
