# frozen_string_literal: true

module FederationKit
  class Service
    class ServiceNotImplementedError < Error; end

    def self.call(*args)
      new(*args).call
    end

    def call
      raise(ServiceNotImplementedError)
    end
  end
end
