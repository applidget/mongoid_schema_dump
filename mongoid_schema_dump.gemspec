# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid_schema_dump/version'

Gem::Specification.new do |spec|
  spec.name          = "mongoid_schema_dump"
  spec.version       = MongoidSchemaDump::VERSION
  spec.authors       = ["rpechayr"]
  spec.email         = ["romain.pechayre@applidget.com"]

  spec.summary       = %q{Extract your Mongoid schema based on a top level class}
  spec.description   = %q{Extract your Mongoid schema based on a top level class}
  spec.homepage      = "https://github.com/applidget/mongoid_schema_dump"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "mongoid", "~> 5"
  spec.add_development_dependency "rspec"
end
