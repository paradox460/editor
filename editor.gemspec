# coding: utf-8
# rubocop:disable all
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'editor/version'

Gem::Specification.new do |spec|
  spec.name          = "editor"
  spec.version       = Editor::VERSION
  spec.authors       = ["Jeff Sandberg"]
  spec.email         = ["paradox460@gmail.com"]
  spec.summary       = %q{A library for invoking the users text editor.}
  spec.description   = %q{Library for opening text editors and getting their content as a string. Useful for command line scripts. Somewhat of an extraction from the excellent pry gem.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
