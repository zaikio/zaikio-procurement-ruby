require "faraday"
require "spyke"
require "zaikio-client-helpers"
require "zaikio/procurement/configuration"
require "zaikio/procurement/authorization_middleware"

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

      def with_token(token)
        original_token = AuthorizationMiddleware.token
        AuthorizationMiddleware.token = token
        yield
      ensure
        AuthorizationMiddleware.token = original_token
      end

      def create_connection
        self.connection = Faraday.new(url: configuration.host,
                                      ssl: { verify: configuration.environment != :test }) do |c|
          c.request     :json
          c.response    :logger, configuration&.logger, headers: false
          c.use         Zaikio::Client::Helpers::Pagination::FaradayMiddleware
          c.use         Zaikio::Client::Helpers::JSONParser
          c.use         AuthorizationMiddleware
          c.adapter     Faraday.default_adapter
        end
      end
    end
  end
end
