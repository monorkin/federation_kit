# frozen_string_literal: true

module FederationKit
  module Plugins
    module Base
      FederationKit.plugin_registry.register(:base, self)

      def self.load_dependencies(base)
        base.plugin(:activity_stream_2)
      end
    end
  end
end
