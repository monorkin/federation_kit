# frozen_string_literal: true

module FederationKit
  def self.plugin_registry
    @plugin_registry ||= FederationKit::PluginRegistry.new
  end

  def self.plugin(plugin, *args, &block)
    if !(plugin.is_a?(Module) || plugin.is_a?(Symbol))
      raise(InvalidPluginError, plugin)
    end

    plugin = plugin_registry.load(plugin) if plugin.is_a?(Symbol)

    if plugin.respond_to?(:load_dependencies, true)
      plugin.load_dependencies(self, *args, &block)
    end

    include plugin::InstanceMethods if defined?(plugin::InstanceMethods)
    extend plugin::ClassMethods if defined?(plugin::ClassMethods)
    FederationKit::Services::ExtensionApplicator.call(plugin, self)

    if plugin.respond_to?(:configure, true)
      plugin.configure(self, *args, &block)
    end
  end
end

require 'federation_kit/version'
require 'federation_kit/error'
require 'federation_kit/plugin_errors'
require 'federation_kit/plugin_registry'
require 'federation_kit/service'
require 'federation_kit/services/string_classifier'
require 'federation_kit/services/extension_applicator'
require 'federation_kit/plugins/base'

FederationKit.plugin FederationKit::Plugins::Base
