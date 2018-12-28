# frozen_string_literal: true

module FederationKit
  module Services
    class ExtensionApplicator < Service
      def initialize(plugin, base)
        @plugin = plugin
        @base = base
      end

      def call
        extensions.each do |klass, (instance_module, class_module)|
          klass.include(instance_module) if instance_module
          klass.extend(class_module) if class_module
        end
      end

      protected

      attr_reader :plugin
      attr_reader :base

      private

      def extensions
        return [] unless plugin.respond_to?(:extends, true)

        extends = plugin.extends

        unless extends.is_a?(Enumerable)
          raise(InvalidExtensionsListError)
        end

        extends.each.with_object({}) do |class_name, hash|
          build_extension(class_name, hash)
        end
      end

      def build_extension(class_name, hash)
        return unless base.const_defined?(class_name)
        klass = base.const_get(class_name)

        ext_class_names =
          ["#{class_name}InstanceMethods", "#{class_name}ClassMethods"]

        hash[klass] = ext_class_names.map do |ext_class_name|
          next unless plugin.const_defined?(ext_class_name)
          plugin.const_get(ext_class_name)
        end
      end
    end
  end
end
