require "faraday"
require "spyke"
require "zaikio-client-helpers"
require "zaikio/procurement/configuration"

# Models
require "zaikio/procurement/base"
require "zaikio/procurement/address"
require "zaikio/procurement/article"
require "zaikio/procurement/variant"
require "zaikio/procurement/variant_search"
require "zaikio/procurement/sku"
require "zaikio/procurement/supplier"
require "zaikio/procurement/contract_request"
require "zaikio/procurement/order"
require "zaikio/procurement/order_line_item"
require "zaikio/procurement/delivery"
require "zaikio/procurement/material_requirement"
require "zaikio/procurement/line_item"
require "zaikio/procurement/material"
require "zaikio/procurement/pricing"
require "zaikio/procurement/site"
require "zaikio/procurement/availability"
require "zaikio/procurement/quantity"
require "zaikio/procurement/job"
require "zaikio/procurement/person"

module Zaikio
  module Procurement
    class << self
      attr_accessor :configuration

      class_attribute :connection

      def configure
        self.connection = nil
        self.configuration ||= Configuration.new
        yield(configuration)

        Base.connection = create_connection
      end

      def with_token(token, &block)
        Zaikio::Client.with_token(token, &block)
      end

      def create_connection
        self.connection = Zaikio::Client.create_connection(configuration)
      end
    end
  end
end
