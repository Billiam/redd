# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "redd/version"

Gem::Specification.new do |spec|
  spec.name          = "redd"
  spec.version       = Redd::VERSION
  spec.authors       = ["Avinash Dwarapu"]
  spec.email         = ["avinash@dwarapu.me"]
  spec.summary       = "A Reddit API Wrapper for Ruby."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  spec.add_dependency "thor", "~> 0.19.1"
  spec.add_dependency "faraday", "~> 0.9.0"
  spec.add_dependency "multi_json", "~> 1.10"
  spec.add_dependency "memoist"
end
