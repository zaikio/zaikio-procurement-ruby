module Zaikio
  class Error < StandardError; end

  class ConnectionError < Zaikio::Error; end

  class ResourceNotFound < Zaikio::Error; end
end

module Spyke
  instance_eval do
    # avoid warning: already initialized constant
    remove_const("ConnectionError")
    remove_const("ResourceNotFound")
  end

  ConnectionError = Class.new Zaikio::ConnectionError
  ResourceNotFound = Class.new Zaikio::ResourceNotFound
end
