# frozen_string_literal: true

require 'ostruct'

module FederationKit
  module Plugins
    module Configuration
      FederationKit.plugin_registry.register(:configuration, self)

      class Config < OpenStruct
        def [](attribute, &block)
          if block
            self[attribute] = block
          else
            super(attribute)
          end
        end

        def []=(attribute, value)
          if value.respond_to?(:call)
            object = self[attribute] || self.class.new
            value.call(object)
            super(attribute, object)
          else
            super(attribute, value)
          end
        end
      end

      module ClassMethods
        def config
          @config ||= Config.new
        end

        def configure(&block)
          block.call(config)
        end
      end
    end
  end
end
