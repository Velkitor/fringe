# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fringe/version'

Gem::Specification.new do |spec|
  spec.name          = "fringe"
  spec.version       = Fringe::VERSION
  spec.authors       = ["Andrew Hecht"]
  spec.email         = ["velkitor@velkitor.com"]
  spec.description   = %q{Ruby client for Apple DEP}
  spec.summary       = %q{Ruby client for Apple DEP}
  spec.homepage      = ""
  spec.license       = ""

  spec.files         = `git ls-files`.split($/)
  spec.executables   = ["fringe"]
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
