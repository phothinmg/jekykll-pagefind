# frozen_string_literal: true

require "rbconfig"
require "open3"
require "jekyll"

require_relative "jekyll/pagefind/version"

module Jekyll
  # module Jekyll::Pagefind
  module Pagefind
    GEM_ROOT = File.expand_path("..", __dir__)

    def self.pagefind_binary_path # rubocop:disable Metrics/MethodLength
      os = RbConfig::CONFIG["host_os"]
      cpu = RbConfig::CONFIG["host_cpu"]

      case os
      when /darwin|mac os/i
        # Differentiate between Apple Silicon and Intel Macs
        if cpu =~ /arm64|aarch64/i
          File.join(GEM_ROOT, "assets", "macos-arm64",
                    "pagefind")
        else
          File.join(GEM_ROOT, "assets", "macos-x64", "pagefind")
        end
      when /linux/i
        # Differentiate between standard servers and ARM instances
        if cpu =~ /arm64|aarch64/i
          File.join(GEM_ROOT, "assets", "linux-arm64",
                    "pagefind")
        else
          File.join(GEM_ROOT, "assets", "linux-x64", "pagefind")
        end
        # spellchecker:disable-next-line
      when /mswin|msys|mingw|cygwin|bccwin/i
        File.join(GEM_ROOT, "assets", "windows-x64", "pagefind.exe")
      else
        raise "Jekyll-Pagefind Mismatch Error: Pagefind binary not provided for host environment: #{os} (#{cpu})"
      end
    end

    def self.run_pagefind(site_destination) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      binary = pagefind_binary_path

      # Force execution bits on UNIX hosts because gem unpacking can reset permissions flags
      # spellchecker:disable-next-line
      if RbConfig::CONFIG["host_os"] !~ /mswin|msys|mingw|cygwin|bccwin/i && !File.executable?(binary)
        File.chmod(0o755, binary)
      end

      # Run the indexer pointing explicitly at Jekyll's output directory
      Jekyll.logger.info "Jekyll-Pagefind:", "Starting Pagefind indexing on target folder..."
      stdout, stderr, status = Open3.capture3("#{binary} --site \"#{site_destination}\"")

      if status.success?
        Jekyll.logger.info "Jekyll-Pagefind:", "Indexing finished successfully!"
        puts stdout
      else
        Jekyll.logger.error "Jekyll-Pagefind Error:", stderr
        raise "Pagefind binary exited with non-zero status code: #{status.exitstatus}"
      end
    end
  end
end

# Hook ensures Jekyll is entirely done writing HTML pages to disk
Jekyll::Hooks.register :site, :post_write do |site|
  # site.dest points dynamically to the configured destination folder (usually '_site')
  Jekyll::Pagefind.run_pagefind(site.dest)
end
