# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jsonlint/version'

Gem::Specification.new do |spec|
  spec.name          = "jsonlint"
  spec.version       = JsonLint::VERSION
  spec.authors       = ["Doug Barth"]
  spec.email         = ["dougbarth@gmail.com"]
  spec.summary       = %q{JSON lint checker}
  spec.description   = %q{Checks JSON files for correct syntax and no silly mistakes}
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'trollop', '~> 2'
  spec.add_dependency 'multi_json', '~> 1.12.1'
  if RUBY_PLATFORM == 'java'
    spec.platform = 'java'
    spec.add_dependency 'jrjackson', '~> 0.4.0'
  else
    spec.add_dependency 'oj', '~> 2'
  end

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "aruba"
end
