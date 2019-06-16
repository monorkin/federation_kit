# frozen_string_literal: true

module FederationKit
  # Returns the global `PluginRegistry` object
  # @return [PluginRegistry]
  def self.plugin_registry
    @plugin_registry ||= FederationKit::PluginRegistry.new
  end

  # Loads a plugin
  # @raise [InvalidPluginError] when `plugin` is of the incorrect type
  # @raise [InvalidExtensionsListError] when the plugin's extensions list isn't
  #        an Enumerable
  # @raise [InvalidPluginNameError] when the plugin name is `nil`
  # @raise [NonExistantPluginError] when the plugin doesn't exist
  # @raise [IncorrectlyRegiseredPluginError] when the plugin didn't register
  #        it self after being loaded
  # @param plugin [Module, Symbol]
  # @param args [Array<Object>]
  # @param block [Block]
  def self.plugin(plugin, *args, &block)
    unless plugin.is_a?(Module) || plugin.is_a?(Symbol)
      raise(InvalidPluginError, plugin)
    end

    plugin = plugin_registry.load(plugin) if plugin.is_a?(Symbol)

    if plugin.respond_to?(:load_dependencies, true)
      plugin.load_dependencies(self, *args, &block)
    end

    extend plugin::ClassMethods if defined?(plugin::ClassMethods)
    include plugin::InstanceMethods if defined?(plugin::InstanceMethods)

    FederationKit::Services::ExtensionApplicator
      .call(plugin, self, *args, &block)

    if plugin.respond_to?(:configure, true)
      plugin.configure(self, *args, &block)
    end
  end
end

require 'federation_kit/version'
require 'federation_kit/error'
require 'federation_kit/plugin_errors'
require 'federation_kit/plugin_registry'
require 'federation_kit/services/base'
require 'federation_kit/services/string/pascal_case'
require 'federation_kit/services/string/camel_case'
require 'federation_kit/services/extension_applicator'
require 'federation_kit/plugins/base'
require 'federation_kit/concerns/auto_define_module'

FederationKit.plugin FederationKit::Plugins::Base
