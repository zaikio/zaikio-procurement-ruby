require "faraday"
require "jwt"
require "concurrent"

module Zaikio
  module Procurement
    class AuthorizationMiddleware < Faraday::Middleware
      def self.token
        @token ||= Concurrent::ThreadLocalVar.new { nil }
        @token.value
      end

      def self.token=(value)
        @token ||= Concurrent::ThreadLocalVar.new { nil }
        @token.value = value
      end

      def self.reset_token
        self.token = nil
      end

      def call(request_env)
        request_env[:request_headers]["Authorization"] = "Bearer #{self.class.token}" if self.class.token

        @app.call(request_env).on_complete do |response_env|
        end
      end
    end
  end
end
