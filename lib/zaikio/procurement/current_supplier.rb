module Zaikio
  module Procurement
    class CurrentSupplier < Base
      self.primary_key = nil
      uri "supplier"
      include_root_in_json :supplier

      def self.find
        all.find_one
      end

      def self.find_with_fallback(fallback)
        all.with_fallback(fallback).find_one
      end
    end
  end
end
