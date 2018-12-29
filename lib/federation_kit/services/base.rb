# frozen_string_literal: true

module FederationKit
  module Services
    class Base
      def self.call(*args)
        new(*args).call
      end

      def call
        raise(NotImplementedError)
      end
    end
  end
end
