
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'one_roster/version'

Gem::Specification.new do |spec|
  spec.name          = 'oneroster'
  spec.version       = OneRoster::VERSION
  spec.authors       = ['Robert Julius']
  spec.email         = ['robertmjulius@gmail.com']

  spec.summary       = 'Wrapper for the OneRoster API.'
  spec.description   = 'Wrapper for the OneRoster API.'
  spec.homepage      = "https://github.com/TCI/oneroster"
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'faraday'
  spec.add_runtime_dependency 'faraday_middleware'
  spec.add_runtime_dependency 'dry-inflector', '~> 1.0.0'
  spec.add_runtime_dependency 'simple_oauth'
  spec.add_runtime_dependency 'oauth'

  spec.add_development_dependency 'bundler', '~> 2.1.4'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-nav'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rubocop', '~>1.53'
  spec.add_development_dependency 'simplecov', '~>0.22'
end
