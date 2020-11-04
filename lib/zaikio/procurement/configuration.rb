require "logger"

module Zaikio
  module Procurement
    class Configuration
      HOSTS = {
        development: "https://procurement.zaikio.test",
        test: "https://procurement.zaikio.test",
        staging: "https://procurement.staging.zaikio.com",
        sandbox: "https://procurement.sandbox.zaikio.com",
        production: "https://procurement.zaikio.com"
      }.freeze

      attr_accessor :host
      attr_reader :environment
      attr_writer :logger

      def initialize
        @environment = :sandbox
      end

      def logger
        @logger ||= Logger.new($stdout)
      end

      def environment=(env)
        @environment = env.to_sym
        @host = host_for(environment)
      end

      private

      def host_for(environment)
        HOSTS.fetch(environment) do
          raise StandardError.new, "Invalid Zaikio::Procurement environment '#{environment}'"
        end
      end
    end
  end
end
