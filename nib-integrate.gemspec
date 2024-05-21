lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nib/integrate/version'

Gem::Specification.new do |spec|
  spec.name          = 'nib-integrate'
  spec.version       = Nib::Integrate::VERSION
  spec.authors       = ['Tom Zmyslo']
  spec.email         = ['tom.zmyslo@telusagcg.com']

  spec.summary       = 'integrates specified docker-compose applications'
  spec.description   = 'integrates specified docker-compose applications'
  spec.homepage      = 'https://github.com/telus-agcg/nib-integrate'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb']
  spec.bindir        = 'bin'
  spec.executables   = ['nib-integrate']
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'nib', '~> 2'

  spec.add_development_dependency 'bundler', '~> 2.5'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
  spec.add_development_dependency 'pry-byebug', '~> 3.5'
  spec.add_development_dependency 'rake', '~> 11.2'
end
