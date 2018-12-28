RSpec.describe 'FederationKit::Version' do
  subject { FederationKit::Version }

  it 'has a version number' do
    expect(subject.to_s).to be_a String
  end

  it 'has a major version number' do
    expect(subject::MAJOR).not_to be nil
  end

  it 'has a minor version number' do
    expect(subject::MINOR).not_to be nil
  end

  it 'has a patch version number' do
    expect(subject::PATCH).not_to be nil
  end
end
