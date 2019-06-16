# frozen_string_literal: true

module FederationKit
  module Services
    module String
      # Converts a String to camel case
      # e.g. `foo bar_baz-cux` -> `fooBarBazCux`
      class CamelCase < Base
        def initialize(string)
          @string = string&.to_s
        end

        def call
          str = PascalCase.call(string)
          return unless str

          str[0] = str[0].downcase
          str
        end

        protected

        attr_reader :string
      end
    end
  end
end
