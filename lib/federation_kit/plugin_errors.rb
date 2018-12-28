module FederationKit
  class IncorrectlyRegiseredPluginError < Error
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def message
      "Plugin '#{name}' didn't correctly register itself"
    end
  end

  class InvalidPluginNameError < Error; end
  class InvalidPluginModuleError < Error; end
  class PluginAlreadyRegisteredError < Error; end
  class NonExistantPluginError < Error; end
end
