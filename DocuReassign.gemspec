Gem::Specification.new do |spec|
  spec.name        = 'DocuReassign'
  spec.version     = '0.0.1'
  spec.date        = '2016-11-02'
  spec.summary     = "Reassign Envelopes Based on User"
  spec.description = ""
  spec.authorss     = ['Sean Smith']
  spec.email       = 'sean.smithy1@gmail.com'
  spec.files       += Dir.glob('{lib, spec}/**/*') + ['README.mb', 'LICENCE.md']
  spec.homepage    = 'http://rubygems.org/gems/DocReassign'
  spec.license       = 'MIT'
  spec.add_runtime_dependency 'mysql2', '~>3.1.0'
  spec.add_development_dependency 'rspec', '~> 2.14.1'
  spec.require_paths = ["lib"]
end
