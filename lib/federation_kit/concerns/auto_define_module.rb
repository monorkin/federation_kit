# frozen_string_literal: true

module FederationKit
  module Concerns
    module AutoDefineModule
      def const_missing(name)
        class_eval("module #{name}; end", __FILE__, __LINE__)
        const_get(name)
      end
    end
  end
end
