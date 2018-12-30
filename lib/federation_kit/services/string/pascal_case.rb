# frozen_string_literal: true

module FederationKit
  module Services
    module String
      class PascalCase < Base
        def initialize(string)
          @string = string&.to_s
        end

        def call
          return unless string
          string
            .gsub(/([A-Z])/, '_\1')
            .gsub(/\t+/, '_')
            .gsub(/\s+/, '_')
            .split('_')\
            .collect(&:capitalize)
            .join
        end

        protected

        attr_reader :string
      end
    end
  end
end
