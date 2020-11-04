require "multi_json"

module Zaikio
  module Procurement
    class JSONParser < Faraday::Response::Middleware
      def on_complete(env)
        connection_error(env) unless /^(2\d\d)|422|404$/.match?(env.status.to_s)

        raise Spyke::ResourceNotFound if env.status.to_s == "404"

        env.body = parse_body(env.body)
      end

      def connection_error(env)
        Zaikio::Procurement.configuration.logger
                           .error("Zaikio::Procurement Status Code #{env.status}, #{env.body}")
        raise Spyke::ConnectionError, "Status Code #{env.status}, #{env.body}"
      end

      def parse_body(body)
        json = MultiJson.load(body, symbolize_keys: true)
        {
          data: json,
          metadata: {},
          errors: json.is_a?(Hash) ? json[:errors] : {}
        }
      rescue MultiJson::ParseError
        {
          data: {},
          metadata: {},
          errors: {}
        }
      end
    end
  end
end
