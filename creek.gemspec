# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'creek/version'

Gem::Specification.new do |spec|
  spec.name          = "creek"
  spec.version       = Creek::VERSION
  spec.authors       = ["pythonicrubyist"]
  spec.email         = ["pythonicrubyist@gmail.com"]
  spec.description   = %q{A Ruby gem that streams and parses large Excel(xlsx and xlsm) files fast and efficiently.}
  spec.summary       = %q{A Ruby gem for parsing large Excel(xlsx and xlsm) files.}
  spec.homepage      = "https://github.com/pythonicrubyist/creek"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.7.0'

  spec.add_development_dependency "bundler", ">= 2.2.10"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', '>= 3.11.0'
  spec.add_development_dependency 'pry-byebug', '>= 3.9.0'

  spec.add_dependency 'nokogiri', '>= 1.10.0'
  spec.add_dependency 'rubyzip', '>= 1.2.2'
  spec.add_dependency 'httparty', '>= 0.15.0'
end
