RSpec.describe FederationKit do
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

  describe '#plugin' do
    before do
      allow(FederationKit::Services::ExtensionApplicator).to(
        receive(:call).and_return([])
      )
    end

    RSpec.shared_examples :acts_like_the_plugin_method do |plugin|
      let(:registry) { instance_double('FederationKit::PluginRegistry') }
      let(:plugin_module) { plugin.is_a?(Module) ? plugin : Module.new }

      before do
        allow(described_class).to(
          receive(:plugin_registry).and_return(registry)
        )
        allow(registry).to receive(:load).and_return(plugin_module)
      end

      context 'with defined dependencies' do
        before do
          allow(plugin_module).to(
            receive(:respond_to?) do |method, _|
              method == :load_dependencies
            end
          )
        end

        it 'calls #load_dependencies on the plugin' do
          allow(plugin_module).to receive(:load_dependencies).and_return(true)
          expect(plugin_module).to receive(:load_dependencies).once
          described_class.plugin(plugin)
        end

        it 'passes all given arguments to #load_dependencies' do
          arguments = [:foo, :bar, :baz]
          block = Proc.new { nil }

          expect(plugin_module).to(
            receive(:load_dependencies)
            .with(described_class, *arguments, &block)
            .once
          )

          described_class.plugin(plugin, *arguments, &block)
        end
      end

      context 'without defined dependencies' do
        it "doesn't call #load_dependencies on the plugin" do
          # This test would raise a NotImplementedError if the method got called
          described_class.plugin(plugin)
        end
      end

      context 'with defined configuration' do
        before do
          allow(plugin_module).to(
            receive(:respond_to?) do |method, _|
              method == :configure
            end
          )
        end

        it 'calls #configure on the plugin' do
          allow(plugin_module).to receive(:configure).and_return(true)
          expect(plugin_module).to receive(:configure).once
          described_class.plugin(plugin)
        end

        it 'passes all given arguments to #configure' do
          arguments = [:foo, :bar, :baz]
          block = Proc.new { nil }

          expect(plugin_module).to(
            receive(:configure)
            .with(described_class, *arguments, &block)
            .once
          )

          described_class.plugin(plugin, *arguments, &block)
        end
      end

      context 'without defined configuration' do
        it "doesn't call #configure on the plugin" do
          # This test would raise a NotImplementedError if the method got called
          described_class.plugin(plugin)
        end
      end
    end

    context 'given a Module' do
      let(:mod) { Module.new }

      it "doesn't load it" do
        registry = instance_double('FederationKit::PluginRegistry')
        allow(described_class).to receive(:plugin_registry).and_return(registry)

        expect(registry).to receive(:load).exactly(0).times

        described_class.plugin(mod)
      end

      include_examples :acts_like_the_plugin_method, Module.new
    end

    context 'given a Symbol' do
      context 'of an existing plugin' do
        let(:mod) { Module.new }

        it 'loads it' do
          registry = instance_double("FederationKit::PluginRegistry")
          allow(described_class).to(
            receive(:plugin_registry).and_return(registry)
          )

          allow(registry).to receive(:load).and_return(mod)
          expect(registry).to receive(:load).once

          described_class.plugin(:test_plugin)
        end

        include_examples :acts_like_the_plugin_method, :test_plugin
      end

      context 'of a non-existant plugin' do
        it 'raises NonExistantPluginError' do
          expect do
            described_class.plugin(:__fake_plugin__)
          end.to raise_error(FederationKit::NonExistantPluginError)
        end
      end
    end

    context 'given nil' do
      it 'raises InvalidPluginError' do
        expect do
          described_class.plugin(nil)
        end.to raise_error(FederationKit::InvalidPluginError)
      end
    end
  end
end
