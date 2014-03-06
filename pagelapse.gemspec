# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pagelapse/version'

Gem::Specification.new do |spec|
  spec.name          = "pagelapse"
  spec.version       = Pagelapse::VERSION
  spec.authors       = ["Robert Lord"]
  spec.email         = ["robert@lord.io"]
  spec.summary       = %q{Generates time-lapses of websites, with ease.}
  spec.description   = %q{}
  spec.homepage      = "https://github.com/lord/pagelapse"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_dependency "capybara"
  spec.add_dependency "poltergeist"
  spec.add_dependency "sinatra"
end
