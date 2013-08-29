# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack-modernizer/version'

Gem::Specification.new do |spec|
  spec.name          = 'rack-modernizer'
  spec.version       = Rack::Modernizer::VERSION
  spec.authors       = ['Tucker Joseph']
  spec.email         = ['tucker@chartboost.com']
  spec.description   = %q{modernizers a body based on a rack env and set of modernizations}
  spec.summary       = %q{see description}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rack'
  spec.add_development_dependency 'rack-test'
end
