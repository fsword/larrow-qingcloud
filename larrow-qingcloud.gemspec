# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'larrow/qingcloud/version'

Gem::Specification.new do |spec|
  spec.name          = 'larrow-qingcloud'
  spec.version       = Larrow::Qingcloud::VERSION
  spec.authors       = ['fsword']
  spec.email         = ['li.jianye@gmail.com']
  spec.summary       = "qingcloud's ruby sdk, unofficial version"
  spec.description   = 'access qingcloud with a simple way for ruby programmer'
  spec.homepage      = 'http://github.com/fsword/larrow-qingcloud'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'promising', '~> 0.3'
  spec.add_development_dependency 'bundler', '~> 1.5'
  spec.add_development_dependency 'rake', '~> 0'
  spec.add_development_dependency 'faraday', '~> 0'
end
