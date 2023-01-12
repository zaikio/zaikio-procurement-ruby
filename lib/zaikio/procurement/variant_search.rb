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

        @response = Zaikio::Procurement::Base.with(path).get
      end

      def results
        @response.results.collect { |variant| Zaikio::Procurement::Variant.new(variant) }
      end

      def available_filters
        @response.available_filters
      end

      private

      def path
        "variants".tap do |qp|
          qp << "?type=#{@type}"
          qp << "&query=#{@query}" if @query
          qp << "&" if @query && @filters.any?
          qp << @filters.to_query("filters") if @filters
        end
      end
    end
  end
end
