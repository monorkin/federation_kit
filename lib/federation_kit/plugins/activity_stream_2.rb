# frozen_string_literal: true

require 'json/ld'
require 'set'

class FederationKit::Object
end

class FederationKit::Actor < FederationKit::Object
end

class FederationKit::Application < FederationKit::Actor
end

class FederationKit::Group < FederationKit::Actor
end

class FederationKit::Organization < FederationKit::Actor
end

class FederationKit::Person < FederationKit::Actor
end

class FederationKit::Service < FederationKit::Actor
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

class FederationKit::OrderedCollectionPage < FederationKit::OrderedCollection
end

module FederationKit
  module Plugins
    module ActivityStream2
      NAME = :activity_stream_2

      FederationKit.plugin_registry.register(NAME, self)

      def self.extends(_base, *_args, &_block)
        %I[object actor application group organization person service link
           activity intransitive_activity collection ordered_collection
           collection_page ordered_collection_page]
      end

      def self.load_dependencies(base, *_args, &_block)
        base.plugin(:configuration)
      end

      def self.configure(base, *_args, &_base)
        base.configure do |c|
          c.object_context ||= 'https://www.w3.org/ns/activitystreams'
        end
      end

      module SerializableClassMethods
        def attributes
          @attributes ||= {}
        end

        def all_attributes
          self.ancestors.reduce(attributes.dup) do |acc, ancestor|
            if ancestor.respond_to?(:attributes)
              acc.merge(ancestor.attributes)
            else
              acc
            end
          end
        end

        def attribute(name, meta: false, accessor: true)
          return unless name
          name = name.to_sym
          return name if attributes[name]
          attributes[name] = { meta: meta }
          attr_accessor(name) if accessor
          name
        end

        def contexts
          @contexts ||= {}
        end

        def included(base)
          copy_attributes_to_class(base)
          super
        end

        def copy_attributes_to_class(klass)
          klass.attributes.merge!(self.attributes)
        end
      end

      module SerializableInstanceMethods
        def to_h
          self.class.all_attributes.each.with_object({}) do |(attr, opts), hash|
            name = opts[:meta] ? "@#{attr}".to_sym : attr
            hash[name] = self.public_send(attr)
          end
        end

        def to_compact_h
          hash = to_h
          __preload_context(hash[:'@context'])
          JSON::LD::API.compact(hash, hash[:'@context'])
        end

        def to_json_ld
          to_compact_h.to_json
        end
        alias_method :to_json, :to_json_ld

        private

        def __preload_context(uri)
          ctx = JSON::LD::Context.new().parse(uri)
          JSON::LD::Context.add_preloaded(uri, ctx)
        end
      end

      module ObjectClassMethods
        include SerializableClassMethods
      end

      module ObjectInstanceMethods
        extend SerializableClassMethods
        include SerializableInstanceMethods

        attribute :id
        attribute :type
        attribute :attachment
        attribute :attributed_to
        attribute :audience
        attribute :content
        attribute :context, meta: true
        attribute :content_map
        attribute :name
        attribute :name_map
        attribute :end_time
        attribute :generator
        attribute :icon
        attribute :image
        attribute :in_reply_to
        attribute :location
        attribute :preview
        attribute :published
        attribute :replies
        attribute :start_time
        attribute :summary
        attribute :summary_map
        attribute :tag
        attribute :updated
        attribute :url
        attribute :to
        attribute :bto
        attribute :cc
        attribute :bcc
        attribute :media_type
        attribute :duration

        def initialize(attrs = {})
          @context = attrs[:context] || FederationKit.config.object_context
        end
      end

      module ActorInstanceMethods
        def initialize(attrs = {})
          super
          @type = 'Actor'
        end
      end

      module ApplicationInstanceMethods
        def initialize(attrs = {})
          super
          @type = 'Application'
        end
      end

      module GroupInstanceMethods
        def initialize(attrs = {})
          super
          @type = 'Group'
        end
      end

      module OrganizationInstanceMethods
        def initialize(attrs = {})
          super
          @type = 'Organization'
        end
      end

      module PersonInstanceMethods
        def initialize(attrs = {})
          super
          @type = 'Person'
        end
      end

      module ServiceInstanceMethods
        def initialize(attrs = {})
          super
          @type = 'Service'
        end
      end

      module LinkClassMethods
        include SerializableClassMethods
      end

      module LinkInstanceMethods
        extend SerializableClassMethods
        include SerializableInstanceMethods

        attribute :id
        attribute :name
        attribute :type
        attribute :hreflang
        attribute :media_type
        attribute :rel
        attribute :height
        attribute :width

        def initialize(attrs = {})
          @type = 'Link'
        end
      end

      module ActivityInstanceMethods
        extend SerializableClassMethods

        attribute :actor
        attribute :object
        attribute :target
        attribute :origin
        attribute :result
        attribute :instrument

        def initialize(attrs = {})
          super
          @type = 'Activity'
        end
      end

      module IntransitiveActivityInstanceMethods
        def initialize(attrs = {})
          super
          @type = 'IntransitiveActivity'
          @id = nil
        end
      end

      module CollectionInstanceMethods
        extend SerializableClassMethods

        attribute :items
        attribute :total_items
        attribute :first
        attribute :last
        attribute :current

        def initialize(attrs = {})
          super
          @type = 'Collection'
        end
      end

      module OrderedCollectionInstanceMethods
        extend SerializableClassMethods

        attribute :ordered_items

        def initialize(attrs = {})
          super
          @type = 'OrderedCollection'
        end

        def ordered_items
          super || items
        end
      end

      module CollectionPageInstanceMethods
        extend SerializableClassMethods

        attribute :part_of
        attribute :next
        attribute :prev

        def initialize(attrs = {})
          super
          @type = 'CollectionPage'
        end
      end

      module OrderedCollectionPageInstanceMethods
        extend SerializableClassMethods

        attribute :part_of
        attribute :next
        attribute :prev
        attribute :start_index

        def initialize(attrs = {})
          super
          @type = 'OrderedCollectionPage'
        end
      end
    end
  end
end

