# frozen_string_literal: true

require "rbconfig"
require_relative "lib/version"

host_os = RbConfig::CONFIG["host_os"]
host_cpu = RbConfig::CONFIG["host_cpu"]

default_pagefind_asset_directory = case host_os
                                   when /darwin|mac os/i
                                     host_cpu =~ /arm64|aarch64/i ? "assets/macos-arm64" : "assets/macos-x64"
                                   when /linux/i
                                     host_cpu =~ /arm64|aarch64/i ? "assets/linux-arm64" : "assets/linux-x64"
                                   when /mswin|msys|mingw|cygwin|bccwin/i
                                     host_cpu =~ /arm64|aarch64/i ? "assets/windows-arm64" : "assets/windows-x64"
                                   else
                                     raise "Unable to determine a default Pagefind asset directory for host environment: #{host_os} (#{host_cpu})"
                                   end

pagefind_asset_directory = ENV.fetch("PAGEFIND_ASSET_DIR", default_pagefind_asset_directory)
pagefind_gem_platform = ENV.fetch("PAGEFIND_GEM_PLATFORM", Gem::Platform::RUBY)

Gem::Specification.new do |spec|
  spec.name = "jekyll-pagefind"
  spec.version = Jekyll::Pagefind::VERSION
  spec.platform = Gem::Platform.new(pagefind_gem_platform)
  spec.authors = ["phothinmg"]
  spec.email = ["phothinmg@disroot.org"]

  spec.summary = "Pagefind plugin for Jekyll"
  spec.description = "Run pagefind binary in jekyll site"
  spec.homepage = "https://rubygems.org/gems/jekyll-pagefind"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/phothinmg/jekykll-pagefind"
  spec.metadata["changelog_uri"] = "https://github.com/phothinmg/jekykll-pagefind/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(__dir__) do
    Dir["README.md", "LICENSE.txt", "lib/**/*", "#{pagefind_asset_directory}/**/*", "jekyll-pagefind.gemspec"]
  end
  spec.require_paths = ["lib"]
  spec.add_dependency "jekyll", "~> 4.4"
  spec.add_dependency "open3", "~> 0.2.1"
end
