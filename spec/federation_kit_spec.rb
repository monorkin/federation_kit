RSpec.describe FederationKit do
  context 'version' do
    it 'has a version number' do
      expect(FederationKit::VERSION).not_to be nil
    end

    it 'has a major version number' do
      expect(FederationKit::MAJOR).not_to be nil
    end

    it 'has a minor version number' do
      expect(FederationKit::MINOR).not_to be nil
    end

    it 'has a patch version number' do
      expect(FederationKit::PATCH).not_to be nil
    end
  end

  describe '#plugin_registry' do
    it 'returns an instance of the plugin registry' do
      expect(described_class.plugin_registry).to(
        be_a(FederationKit::PluginRegistry)
      )
    end

    it 'memoizes the plugin registry' do
      registry = described_class.plugin_registry
      expect(described_class.plugin_registry).to eq(registry)
      expect(described_class.plugin_registry).to eq(registry)
    end
  end
end
