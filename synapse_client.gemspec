# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'synapse_client/version'

Gem::Specification.new do |spec|
  spec.name          = "synapse_client"
  spec.version       = SynapseClient::VERSION
  spec.authors       = ["Miles Matthias"]
  spec.email         = ["miles.matthias@gmail.com"]
  spec.summary       = %q{A ruby client for the SynapsePay.com API.}
  spec.description   = %q{A ruby client for the SynapsePay.com API. Read SynapsePay API documentation at dev.synapsepay.com.}
  spec.homepage      = "https://github.com/milesmatthias/synapse_client"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'rest-client', '~> 1.7', '>= 1.7.2'
  spec.add_runtime_dependency 'map'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry", "~> 0.9.0"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "coveralls"
end
