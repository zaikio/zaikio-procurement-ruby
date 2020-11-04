module Zaikio
  module Procurement
    class Supplier < Base
      uri "suppliers(/:id)"

      def search(query = nil, options = {})
        search_path = String.new(uri.to_s).tap do |path|
          path << "/searches?"
          path << "query=#{query}" if query
          path << "&" if query && options.any?
          path << options.to_query if options
        end

        unless options.respond_to?(:stringify_keys)
          raise ArgumentError, "When using additional search parameters, you must pass a hash as an argument."
        end

        Zaikio::Procurement::Variant.with(search_path)
      end
    end
  end
end
