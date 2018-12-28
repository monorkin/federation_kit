# frozen_string_literal: true

module FederationKit
  module Plugins
    module ActivityPub
      FederationKit.plugin_registry.register(:activity_pub, self)

      module ClassMethods; end
      module InstanceMethods; end
    end
  end
end
