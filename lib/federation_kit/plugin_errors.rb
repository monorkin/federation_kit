# frozen_string_literal: true

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

  class InvalidPluginError < Error
    attr_reader :plugin

    def initialize(plugin)
      @plugin = plugin
    end

    def message
      "'#{plugin}' is not a valid plugin! " \
        'Valid plugin types are Module or Symbol.'
    end
  end

  class InvalidPluginNameError < Error; end
  class InvalidPluginModuleError < Error; end
  class PluginAlreadyRegisteredError < Error; end
  class NonExistantPluginError < Error; end
  class InvalidExtensionsListError < Error; end
end
