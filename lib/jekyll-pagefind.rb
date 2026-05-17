# frozen_string_literal: true

require "rbconfig"
require "open3"
require "jekyll"

require_relative "version"

module Jekyll
  # module Jekyll::Pagefind
  module Pagefind
    GEM_ROOT = File.expand_path("..", __dir__)

    def self.pagefind_binary_path # rubocop:disable Metrics/MethodLength,Metrics/PerceivedComplexity
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
        # Differentiate between Intel/AMD and ARM Windows machines
        if cpu =~ /arm64|aarch64/i
          File.join(GEM_ROOT, "assets", "windows-arm64", "pagefind.exe")
        else
          File.join(GEM_ROOT, "assets", "windows-x64", "pagefind.exe")
        end
      else
        raise "Jekyll-Pagefind Mismatch Error: Pagefind binary not provided for host environment: #{os} (#{cpu})"
      end
    end

    # valid the cli flag
    def self.valid_args(arg)
      %w[output_subdir exclude_selectors keep_index_url quiet].include?(arg)
    end

    # Converts Jekyll config options into matching Pagefind command line flags
    def self.build_cli_arguments(config) # rubocop:disable Metrics/MethodLength,Metrics/CyclomaticComplexity
      plugin_config = config["jekyll_pagefind"] || {}
      args = []

      plugin_config.each do |key, value|
        next unless valid_args(key)

        # Transform snake_case keys to kebab-case (e.g., keep_index_url -> keep-index-url)
        flag_name = key.to_s.gsub("_", "-")

        case value
        when TrueClass
          # Boolean flags like --keep-index-url require no attached value
          args << "--#{flag_name}"
        when FalseClass
          # Ignore false booleans unless Pagefind specifically supports a negative override
          next
        when Array
          # Arrays like exclude_selectors need to be repeated: --exclude-selectors ".footer" --exclude-selectors "nav"
          value.each { |val| args << "--#{flag_name} \"#{val}\"" }
        else
          # Strings or numbers like --bundle-dir "search"
          args << "--#{flag_name} \"#{value}\""
        end
      end
      args.join(" ")
    end

    def self.run_pagefind(site_destination, extra_arguments = "") # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      binary = pagefind_binary_path

      # Force execution bits on UNIX hosts because gem unpacking can reset permissions flags
      # spellchecker:disable-next-line
      if RbConfig::CONFIG["host_os"] !~ /mswin|msys|mingw|cygwin|bccwin/i && !File.executable?(binary)
        File.chmod(0o755, binary)
      end

      # Combine the mandatory --site parameter with any user-defined configuration flags
      full_command = "#{binary} --site \"#{site_destination}\" #{extra_arguments}".strip

      Jekyll.logger.info "Jekyll-Pagefind:", "Running command: #{full_command}"
      stdout, stderr, status = Open3.capture3(full_command)

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
  # 1. Parse your plugin settings out of site.config
  custom_flags = Jekyll::Pagefind.build_cli_arguments(site.config)
  # 2. Run Pagefind with the compiled flags
  Jekyll::Pagefind.run_pagefind(site.dest, custom_flags)
end
