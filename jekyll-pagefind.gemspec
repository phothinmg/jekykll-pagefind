# frozen_string_literal: true

require_relative "lib/jekyll/pagefind/version"

Gem::Specification.new do |spec|
  spec.name = "jekyll-pagefind"
  spec.version = Jekyll::Pagefind::VERSION
  spec.authors = ["phothinmg"]
  spec.email = ["phothinmg@disroot.org"]

  spec.summary = "Pagefind plugin for Jekyll"
  spec.description = "Run pagefind binary in jekyll site"
  spec.homepage = "https://rubygems.org/gems/jekyll-pagefind"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(__dir__) do
    Dir["README.md", "LICENSE.txt", "lib/**/*", "jekyll-foo.gemspec"]
  end
  spec.require_paths = ["lib"]
  spec.add_dependency "jekyll", "~> 3.10"
end
