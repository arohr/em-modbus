# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'modbus/version'

Gem::Specification.new do |spec|
  spec.name          = 'em-modbus'
  spec.version       = Modbus::VERSION
  spec.authors       = ['Andy Rohr']
  spec.email         = ['andy.rohr@mindclue.ch']
  spec.summary       = %q{Modbus Client and Server for eventmachine.}
  spec.description   = %q{Ruby implementation of the Modbus protocol.}
  spec.homepage      = ''
  spec.license       = 'All rights reserved.'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'eventmachine'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
