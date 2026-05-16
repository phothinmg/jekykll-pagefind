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
  spec.metadata["source_code_uri"] = "https://github.com/phothinmg/jekykll-pagefind"
  spec.metadata["changelog_uri"] = "https://github.com/phothinmg/jekykll-pagefind/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    Dir["README.md", "LICENSE.txt", "lib/**/*", "assets/**/*", "jekyll-pagefind.gemspec"]
  end
  spec.require_paths = ["lib"]
  spec.add_dependency "jekyll", "~> 4.4"
  spec.add_dependency "open3", "~> 0.2.1"
end
