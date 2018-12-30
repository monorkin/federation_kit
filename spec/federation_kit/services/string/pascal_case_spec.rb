RSpec.describe FederationKit::Services::String::PascalCase do
  describe '#call' do
    context 'given a capitalized string' do
      it 'returns the coresponding class name' do
        expect(described_class.call('FooBarBaz')).to eq('FooBarBaz')
        expect(described_class.call('fooBarBaz')).to eq('FooBarBaz')
      end
    end

    context 'given an underscored string' do
      it 'returns the coresponding class name' do
        expect(described_class.call('Foo_Bar_Baz')).to eq('FooBarBaz')
        expect(described_class.call('foo_Bar_Baz')).to eq('FooBarBaz')
      end
    end

    context 'given an underscored and capitalized string' do
      it 'returns the coresponding class name' do
        expect(described_class.call('FooBar_Baz')).to eq('FooBarBaz')
        expect(described_class.call('fooBar_Baz')).to eq('FooBarBaz')
      end
    end

  end
end
