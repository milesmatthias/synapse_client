Gem::Specification.new do |s|
  s.name        = "synapse_client"
  s.version     = "0.0.1"
  s.date        = "2015-03-16"
  s.summary     = "A client for interacting with the SynapsePay.com API."
  s.description = "A client for interacting with the SynapsePay.com API."
  s.authors     = ["Miles Matthias"]
  s.email       = "miles.matthias@gmail.com"
  s.homepage    = "https://github.com/milesmatthias/synapse_client"
  s.license     = "MIT"
  #s.add_dependency(%q<rest-client>, ["~> 1.7.2"])
  s.add_runtime_dependency 'rest-client', '~> 1.7', '>= 1.7.2'
end
