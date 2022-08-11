require "logger"

module Zaikio
  module Procurement
    class Configuration < Zaikio::Client::Helpers::Configuration
      def self.hosts
        {
          development: "https://procurement.zaikio.test/api/v2/",
          test: "https://procurement.zaikio.test/api/v2/",
          staging: "https://procurement.staging.zaikio.com/api/v2/",
          sandbox: "https://procurement.sandbox.zaikio.com/api/v2/",
          production: "https://procurement.zaikio.com/api/v2/"
        }.freeze
      end
    end
  end
end
