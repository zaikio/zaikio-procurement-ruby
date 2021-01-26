require "faraday"
require "spyke"
require "zaikio/procurement/configuration"
require "zaikio/procurement/json_parser"
require "zaikio/procurement/authorization_middleware"

# Models
require "zaikio/error"
require "zaikio/procurement/base"
require "zaikio/procurement/article"
require "zaikio/procurement/variant"
require "zaikio/procurement/substrate_search"
require "zaikio/procurement/sku"
require "zaikio/procurement/price"
require "zaikio/procurement/supplier"
require "zaikio/procurement/contract"
require "zaikio/procurement/contract_request"
require "zaikio/procurement/sales_group"
require "zaikio/procurement/order"
require "zaikio/procurement/order_line_item"
require "zaikio/procurement/delivery"
require "zaikio/procurement/delivery_line_item"
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
        AuthorizationMiddleware.token = token
        yield
      ensure
        AuthorizationMiddleware.reset_token
      end

      def create_connection
        self.connection = Faraday.new(url: "#{configuration.host}/consumers/api/v1/",
                                      ssl: { verify: configuration.environment != :test }) do |c|
          c.request     :json
          c.response    :logger, configuration&.logger
          c.use         JSONParser
          c.use         AuthorizationMiddleware
          c.adapter     Faraday.default_adapter
        end
      end
    end
  end
end
