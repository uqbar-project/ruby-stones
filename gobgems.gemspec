# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gobgems/version'

Gem::Specification.new do |spec|
  spec.name          = 'gobgems'
  spec.version       = Gobgems::VERSION
  spec.authors       = ['Federico Aloi', 'Franco Bulgarelli']
  spec.email         = ['federico.aloi@gmail.com', 'flbulgarelli@yahoo.com.ar']
  spec.summary       = 'Pure ruby library that implements a Gobstones-like board and dsl'
  spec.description   = 'Write Gobstones program within Ruby'
  spec.homepage      = 'https://github.com/flbulgarelli/gobgems'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.executables << 'gobgems'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 2'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
