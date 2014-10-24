# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'elasticsearch/rails2/version'

Gem::Specification.new do |spec|
  spec.name          = "elasticsearch-rails2"
  spec.version       = Elasticsearch::Rails2::VERSION
  spec.authors       = ["Edgar Gonzalez"]
  spec.email         = ["edgargonzalez@gmail.com"]
  spec.description   = "Rails 2.3 ActiveRecord integrations for Elasticsearch"
  spec.summary       = "Rails 2.3 ActiveRecord integrations for Elasticsearch"
  spec.homepage      = "https://github.com/edgar/elasticsearch-rails2"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = "1.9.3"

  spec.add_dependency "elasticsearch", '>= 1.0.5'
  spec.add_dependency "activerecord", '2.3.18'
  spec.add_dependency "hashie"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', "~> 3.1.0"
  spec.add_development_dependency 'sqlite3'
end
