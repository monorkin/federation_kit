module FederationKit
  class PluginRegistry
    def initialize
      @store = {}
    end

    def register(name, mod)
      raise(FederationKit::InvalidPluginModuleError) unless mod.is_a?(Module)
      raise(FederationKit::InvalidPluginNameError) if name.nil?
      raise(FederationKit::PluginAlreadyRegisteredError) if registered?(name)

      store[name.to_s] = mod
      fetch(name)
    end

    def registered?(name)
      !fetch(name).nil?
    end

    def load(name)
      raise(InvalidPluginNameError) if name.nil?

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

    def fetch(name)
      store[name&.to_s]
    end
    alias_method :[], :fetch

    protected

    attr_reader :store
  end
end
