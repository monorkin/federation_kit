RSpec.describe FederationKit::PluginRegistry do
  subject { described_class.new }

  describe '#register' do
    context 'given valid arguments' do
      let(:name) { :test_plugin }
      let(:mod) { Module.new }

      it 'stores the plugin' do
        subject.register(name, mod)
        expect(subject.registered?(name)).to eq(true)
      end

      it 'returns the plugin module' do
        expect(subject.register(name, mod)).to eq(mod)
      end
    end

    context 'called twice with the same name' do
      let(:name) { :test_plugin }
      let(:mod) { Module.new }

      it 'raises PluginAlreadyRegisteredError' do
        subject.register(name, mod)
        expect do
          subject.register(name, mod)
        end.to raise_error(FederationKit::PluginAlreadyRegisteredError)
      end
    end

    context 'given no name' do
      let(:name) { nil }
      let(:mod) { Module.new }

      it 'raises InvalidPluginNameError' do
        expect do
          subject.register(name, mod)
        end.to raise_error(FederationKit::InvalidPluginNameError)
      end
    end

    context 'given no module' do
      let(:name) { :test_plugin }
      let(:mod) { nil }

      it 'raises InvalidPluginModuleError' do
        expect do
          subject.register(name, mod)
        end.to raise_error(FederationKit::InvalidPluginModuleError)
      end
    end
  end

  describe '#registered?' do
    let(:name) { :test_plugin }
    let(:mod) { Module.new }

    before do
      subject.register(name, mod)
    end

    context 'given name of unregistred module' do
      it 'returns false' do
        expect(subject.registered?("FAKE-#{name}")).to eq(false)
      end
    end

    context 'given name of registred module' do
      it 'returns true' do
        expect(subject.registered?(name)).to eq(true)
      end
    end

    context 'given nil as a name' do
      it 'returns false' do
        expect(subject.registered?(nil)).to eq(false)
      end
    end
  end

  describe '#fetch' do
    let(:first_name) { :first_test_plugin }
    let(:first_mod) { Module.new }
    let(:second_name) { :second_test_plugin }
    let(:second_mod) { Module.new }
    let(:third_name) { :third_test_plugin }
    let(:third_mod) { Module.new }

    before do
      subject.register(first_name, first_mod)
      subject.register(second_name, second_mod)
      subject.register(third_name, third_mod)
    end

    context 'given a name of a registered plugin' do
      it 'returns the module of that plugin' do
        expect(subject.fetch(first_name)).to eq(first_mod)
        expect(subject.fetch(second_name)).to eq(second_mod)
        expect(subject.fetch(third_name)).to eq(third_mod)
      end
    end

    context 'given a name of an unregistered plugin' do
      it 'raises NonExistantPluginError' do
        expect do
          subject.fetch("FAKE-#{third_name}")
        end.to raise_error(FederationKit::NonExistantPluginError)
      end

      it 'returns the alternate value if given' do
        object = BasicObject.new
        expect(subject.fetch("FAKE-#{third_name}", object)).to eq(object)
      end
    end

    context 'given nil' do
      it 'raises NonExistantPluginError' do
        expect do
          subject.fetch("FAKE-#{third_name}")
        end.to raise_error(FederationKit::NonExistantPluginError)
      end
    end
  end

  describe '#load' do
    let(:registered_plugin_name) { :first_test_plugin }
    let(:registered_plugin_mod) { Module.new }
    let(:unregistered_plugin_name) { :second_test_plugin }
    let(:unregistered_plugin_mod) { Module.new }

    before do
      subject.register(registered_plugin_name, registered_plugin_mod)
    end

    context 'given an existing plugin' do
      before do
        allow(subject).to receive(:require).and_return(true)
      end

      context 'that is correctly registered' do
        it 'returns the the plugin module' do
          expect(subject.load(registered_plugin_name)).to(
            eq(registered_plugin_mod)
          )
        end
      end

      context 'that was not correctly registered' do
        it 'raises IncorrectlyRegiseredPluginError' do
          expect do
            subject.load(unregistered_plugin_name)
          end.to raise_error(FederationKit::IncorrectlyRegiseredPluginError)
        end
      end
    end

    context 'given a non-existent plugin' do
      it 'raises an NonExistantPluginError' do
        expect do
          subject.load(:___very_fake_plugin___)
        end.to raise_error(FederationKit::NonExistantPluginError)
      end
    end

    context 'given nil' do
      it 'raises an InvalidPluginNameError' do
        expect do
          subject.load(nil)
        end.to raise_error(FederationKit::InvalidPluginNameError)
      end
    end
  end
end
