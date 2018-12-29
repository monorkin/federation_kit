# frozen_string_literal: true

module FederationKit
  module Services
    class ExtensionApplicator < Base
      def initialize(plugin, base, *args, &block)
        @plugin = plugin
        @base = base
        @args = args
        @block = block
      end

      def call
        return unless base.is_a?(Module)
        return unless plugin.is_a?(Module)
        extensions.each do |klass, (instance_module, class_module)|
          klass.extend(class_module) if class_module
          klass.include(instance_module) if instance_module
        end
        extensions
      end

      protected

      attr_reader :plugin
      attr_reader :base
      attr_reader :args
      attr_reader :block

      private

      def extensions
        return [] unless plugin.respond_to?(:extends, true)

        extends = plugin.extends(base, *args, &block)

        unless extends.is_a?(Enumerable)
          raise(InvalidExtensionsListError)
        end

        extends.each.with_object({}) do |class_name, hash|
          build_extension(class_name, hash)
        end
      end

      def build_extension(class_name, hash)
        class_name =
          FederationKit::Services::StringClassifier.call(class_name)
          .gsub("#{base}::", '')

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
