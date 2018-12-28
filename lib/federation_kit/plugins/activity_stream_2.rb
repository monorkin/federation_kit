# frozen_string_literal: true

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

module FederationKit
  module Plugins
    module ActivityStream2
      FederationKit.plugin_registry.register(:activity_stream_2, self)

      def self.extends(_)
        [:object]
      end

      module ObjectInstanceMethods
        attr_accessor :id
        attr_accessor :type
        attr_accessor :attachment
        attr_accessor :attributed_to
        attr_accessor :audience
        attr_accessor :content
        attr_accessor :context
        attr_accessor :content_map
        attr_accessor :name
        attr_accessor :name_map
        attr_accessor :end_time
        attr_accessor :generator
        attr_accessor :icon
        attr_accessor :image
        attr_accessor :in_reply_to
        attr_accessor :location
        attr_accessor :preview
        attr_accessor :published
        attr_accessor :replies
        attr_accessor :start_time
        attr_accessor :summary
        attr_accessor :summary_map
        attr_accessor :tag
        attr_accessor :updated
        attr_accessor :url
        attr_accessor :to
        attr_accessor :bto
        attr_accessor :cc
        attr_accessor :bcc
        attr_accessor :media_type
        attr_accessor :duration

        def context
          @context || 'https://www.w3.org/ns/activitystreams'
        end
      end
    end
  end
end

