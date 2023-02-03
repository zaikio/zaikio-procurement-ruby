module Zaikio
  module Procurement
    class VariantSearch
      def initialize(type: "all", query: nil, **filters)
        @type         = type.split.join
        @query        = query
        @filters      = filters

        unless @filters.respond_to?(:stringify_keys)
          raise ArgumentError, "When using additional search parameters, you must pass a hash as an argument."
        end

        @response = Zaikio::Procurement::Base
                    .request(:get, "variants", type: @type, query: @query, filters: @filters)&.body&.dig("data")
      end

      def results
        @response["results"].collect { |variant| Zaikio::Procurement::Variant.new(variant) }
      end

      def available_filters
        @response["available_filters"]
      end
    end
  end
end
