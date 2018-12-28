# frozen_string_literal: true

module FederationKit
  module Plugins
    module ActivityStream2
      FederationKit.plugin_registry.register(:activity_stream_2, self)

      module ClassMethods; end
      module InstanceMethods; end
    end
  end
end
