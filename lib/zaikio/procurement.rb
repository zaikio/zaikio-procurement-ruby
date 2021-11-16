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
require "zaikio/procurement/substrate_search"
require "zaikio/procurement/sku"
require "zaikio/procurement/price"
require "zaikio/procurement/supplier"
require "zaikio/procurement/contract"
require "zaikio/procurement/contract_request"
require "zaikio/procurement/sales_group"
require "zaikio/procurement/sales_group_membership"
require "zaikio/procurement/order"
require "zaikio/procurement/order_line_item"
require "zaikio/procurement/delivery"
require "zaikio/procurement/delivery_line_item"
require "zaikio/procurement/current_supplier"
require "zaikio/procurement/material_requirement"
require "zaikio/procurement/material_availability_check"

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

      def connection_path
        "#{configuration.host}/#{configuration.flavor.to_s.pluralize}/api/v1/"
      end

      def create_connection
        self.connection = Faraday.new(url: connection_path,
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
