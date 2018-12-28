lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'federation_kit/version'

Gem::Specification.new do |spec|
  spec.name          = 'federation_kit'
  spec.version       = FederationKit::Version.to_s
  spec.authors       = ['Stanko K.R.']
  spec.email         = ['hey@stanko.io']

  spec.summary       = %q{
    FederationKit provides everything you need to create federated web
    applications
  }
  spec.description   = %q{
    FederationKit is an extendible set of tools to integrate your web
    application with the ActivityStream and/or ActivityPub protocols through
    which it can part take in a federation of applications
  }
  spec.homepage      = 'https://github.com/monorkin/federation_kit'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/monorkin/federation_kit'
    spec.metadata['changelog_uri'] = 'https://github.com/monorkin/federation_kit/blob/master/CHANGELOG.md'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.17'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry'
end
