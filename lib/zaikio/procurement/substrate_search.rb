module Zaikio
  module Procurement
    class SubstrateSearch
      def initialize(query = nil, options = {})
        @query        = query
        @supplier     = options.delete(:supplier_id)
        @options      = options
        @article_type = "substrate"

        unless @options.respond_to?(:stringify_keys)
          raise ArgumentError, "When using additional search parameters, you must pass a hash as an argument."
        end

        @response = Zaikio::Procurement::Base.with(path).get
      end

      def results
        @response.results.collect { |variant| Zaikio::Procurement::Variant.new(variant) }
      end

      def facets
        @response.facets
      end

      private

      def path
        String.new(@article_type).tap do |qp|
          qp << "/#{@supplier}" if @supplier
          qp << "/variants/search?"
          qp << "query=#{@query}" if @query
          qp << "&" if @query && @options.any?
          qp << @options.to_query if @options
        end
      end
    end
  end
end
