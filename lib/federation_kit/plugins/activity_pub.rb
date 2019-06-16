# frozen_string_literal: true

class FederationKit::Source
end

module FederationKit
  module Plugins
    module ActivityPub
      NAME = :activity_pub

      FederationKit.plugin_registry.register(NAME, self)

      def self.extends(_base, *_args, &_block)
        %I[object source actor]
      end

      def self.load_dependencies(base, *_args, &_block)
        base.plugin(:configuration)
        base.plugin(:activity_stream_2)
      end

      def self.configure(base, *_args, &_base)
        base.configure do |c|
          c.accepted_request_content_types ||= [
            'application/ld+json; profile="https://www.w3.org/ns/activitystreams"',
            'application/activity+json'
          ]
        end
      end

      SerializableClassMethods =
        FederationKit::Plugins::ActivityStream2::Serializable::ClassMethods

      SerializableInstanceMethods =
        FederationKit::Plugins::ActivityStream2::Serializable::InstanceMethods

      module Object::InstanceMethods
        extend SerializableClassMethods

        attribute :source
      end

      module Source::ClassMethods
        include SerializableClassMethods
      end

      module Source::InstanceMethods
        extend SerializableClassMethods
        include SerializableInstanceMethods

        attribute :content
        attribute :media_type
      end

      module Actor::InstanceMethods
        extend SerializableClassMethods

        attribute :inbox
        attribute :outbox
        attribute :following
        attribute :followers
        attribute :liked
        attribute :shares
        attribute :streams
        attribute :preffered_username
        attribute :endpoints
        attribute :proxy_url
        attribute :oauth_authorization_endpoint
        attribute :oauth_token_endpoint
        attribute :provide_client_key
        attribute :sign_client_key
        attribute :shared_inbox
      end
    end
  end
end
