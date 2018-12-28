RSpec.describe FederationKit::Services::ExtensionApplicator do
  describe '#call' do
    let(:plugin) do
      module TestPlugin
        def self.extends; [FederationKit::Object, :actor]; end
        module ObjectInstanceMethods; end
        module ObjectClassMethods; end
        module ActorInstanceMethods; end
      end

      TestPlugin
    end

  end
end
