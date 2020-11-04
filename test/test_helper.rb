ENV["RACK_ENV"] = "test"

require "active_support/all"
require "minitest/autorun"
require "mocha/minitest"
require "vcr"
require "webmock/minitest"
require "zaikio/procurement"
require "pry"

# Filter out the backtrace from minitest while preserving the one from other libraries.
Minitest.backtrace_filter = Minitest::BacktraceFilter.new

VCR.configure do |config|
  config.cassette_library_dir = "test/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

class ActiveSupport::TestCase
end
