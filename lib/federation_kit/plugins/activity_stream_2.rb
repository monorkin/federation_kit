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

class FederationKit::Object
end

class FederationKit::Actor < FederationKit::Object
end

class FederationKit::Link
end

class FederationKit::Activity < FederationKit::Object
end

class FederationKit::IntransitiveActivity < FederationKit::Activity
end

class FederationKit::Collection < FederationKit::Object
end

class FederationKit::OrderedCollection < FederationKit::Collection
end

class FederationKit::CollectionPage < FederationKit::Collection
end

class FederationKit::OrderedCollectionPage < FederationKit::CollectionPage
end
