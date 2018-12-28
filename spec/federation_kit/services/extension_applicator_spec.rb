RSpec.describe FederationKit::Services::ExtensionApplicator do
  describe '#call' do
    let(:base) do
      module TestBase
        module Foo; end
        module Bar; end
        module FooBar; end
      end

      TestBase
    end

    let(:plugin) do
      module TestPlugin
        def self.extends; [TestBase::Foo, :bar, :foo_bar, :__fake]; end
        module FooInstanceMethods; end
        module FooClassMethods; end
        module BarInstanceMethods; end
        module FooBarClassMethods; end
      end

      TestPlugin
    end


    context 'given base and plugin Modules' do
      it 'extends the base with the appropriate class and instance methods' do
        expect(base::Foo).to receive(:include).with(plugin::FooInstanceMethods)
        expect(base::Foo).to receive(:extend).with(plugin::FooClassMethods)
        expect(base::Bar).to receive(:include).with(plugin::BarInstanceMethods)
        expect(base::FooBar).to receive(:extend).with(plugin::FooBarClassMethods)
        described_class.call(plugin, base)
      end

      it 'returns the extensions hash' do
        expect(described_class.call(plugin, base)).to be_a(Hash)
      end
    end

    context 'given non-Module base' do
      it 'returns nil' do
        expect(described_class.call(plugin, nil)).to eq(nil)
      end
    end

    context 'given non-Module plugin' do
      it 'returns nil' do
        expect(described_class.call(nil, base)).to eq(nil)
      end
    end
  end
end
