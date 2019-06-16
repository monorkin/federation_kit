# frozen_string_literal: true

module FederationKit
  class PluginRegistry
    NO_VALUE = BasicObject.new
    private_constant :NO_VALUE

    def initialize
      @store = {}
    end

    # Used to add a plugin to the registry
    # @param name [#to_s]
    # @param mod [Module]
    # @return [Module]
    def register(name, mod)
      raise(FederationKit::InvalidPluginModuleError) unless mod.is_a?(Module)
      raise(FederationKit::InvalidPluginNameError) if name.nil?
      raise(FederationKit::PluginAlreadyRegisteredError) if registered?(name)

      store[name.to_s] = mod
      fetch(name)
    end

    # Checks if a plugins is NOT registred
    # @param name [#to_s]
    # @return [true, false]
    def unregistred?(name)
      fetch(name, nil).nil?
    end

    # Checks if a plugins is registred
    # @param name [#to_s]
    # @return [true, false]
    def registered?(name)
      !unregistred?(name)
    end

    # Tries to load a built-in plugin by name
    # @raise [InvalidPluginNameError] when the name is `nil`
    # @raise [NonExistantPluginError] when the plugin doesn't exist
    # @raise [IncorrectlyRegiseredPluginError] when the plugin didn't register
    #        it self after being loaded
    # @param name [#to_s]
    # @return [Module]
    def load(name)
      raise(FederationKit::InvalidPluginNameError) if name.nil?

      begin
        require "federation_kit/plugins/#{name}"
      rescue LoadError
        raise(FederationKit::NonExistantPluginError)
      end

      unless registered?(name)
        raise(FederationKit::IncorrectlyRegiseredPluginError, name)
      end

      fetch(name)
    end

    # Returns the plugin module registered with the given name
    # @raise [NonExistantPluginError] when the plugin doesn't exist and no
    #                                 alternative value was given
    # @param name [#to_s]
    # @param alt_value [Object]
    # @return [Module, Object]
    def fetch(name, alt_value = NO_VALUE)
      value = store[name&.to_s]

      if alt_value == NO_VALUE
        value || raise(FederationKit::NonExistantPluginError)
      else
        value || alt_value
      end
    end

    # Returns the plugin module registered with the given name
    # @param name [#to_s]
    # @return [Module, nil]
    def [](name)
      fetch(name, nil)
    end

    protected

    attr_reader :store
  end
end
