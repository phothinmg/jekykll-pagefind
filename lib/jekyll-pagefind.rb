# frozen_string_literal: true

require "rbconfig"
require "open3"
require "jekyll"
require "shellwords"

require_relative "version"

module Jekyll
  # module Jekyll::Pagefind
  module Pagefind
    GEM_ROOT = File.expand_path("..", __dir__)
    PLATFORM_HELP = "Install a matching platform gem or add your deploy platform to Gemfile.lock with bundle lock --add-platform x86_64-linux-gnu x86_64-linux-musl aarch64-linux-gnu aarch64-linux-musl." # rubocop:disable Layout/LineLength
    PLATFORM_PREFIXES = {
      /darwin|mac os/i => "macos",
      /linux/i => "linux",
      /mswin|msys|mingw|cygwin|bccwin/i => "windows"
    }.freeze

    def self.pagefind_binary_path
      os = RbConfig::CONFIG["host_os"]
      cpu = RbConfig::CONFIG["host_cpu"]

      binary = File.join(
        GEM_ROOT,
        "assets",
        platform_directory(os, cpu),
        binary_name(os)
      )

      return binary if File.exist?(binary)

      raise "Jekyll-Pagefind Mismatch Error: no packaged Pagefind binary was found for #{os} (#{cpu}). #{PLATFORM_HELP}"
    end

    def self.platform_directory(os, cpu)
      platform = PLATFORM_PREFIXES.find { |pattern, _value| os.match?(pattern) }&.last

      unless platform
        raise(
          "Jekyll-Pagefind Mismatch Error: " \
          "Pagefind binary not provided for host environment: #{os} (#{cpu})"
        )
      end

      "#{platform}-#{arm_cpu?(cpu) ? "arm64" : "x64"}"
    end

    def self.binary_name(os)
      windows_host?(os) ? "pagefind.exe" : "pagefind"
    end

    def self.arm_cpu?(cpu)
      cpu =~ /arm64|aarch64/i
    end

    def self.windows_host?(os)
      os =~ /mswin|msys|mingw|cygwin|bccwin/i
    end

    # valid the cli flag
    def self.valid_arg?(arg)
      %w[output_subdir exclude_selectors keep_index_url quiet].include?(arg)
    end

    # Converts Jekyll config options into matching Pagefind command line flags
    def self.build_cli_arguments(config) # rubocop:disable Metrics/MethodLength,Metrics/CyclomaticComplexity
      plugin_config = config["jekyll_pagefind"] || {}
      args = []

      plugin_config.each do |key, value|
        next unless valid_arg?(key)

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

    def self.run_pagefind(site_destination, extra_arguments = "") # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
      binary = pagefind_binary_path

      # Force execution bits on UNIX hosts because gem unpacking can reset permissions flags
      # spellchecker:disable-next-line
      if RbConfig::CONFIG["host_os"] !~ /mswin|msys|mingw|cygwin|bccwin/i && !File.executable?(binary)
        File.chmod(0o755, binary)
      end

      # Combine the mandatory --site parameter with any user-defined configuration flags
      full_command = [
        Shellwords.escape(binary),
        "--site",
        Shellwords.escape(site_destination),
        extra_arguments
      ].join(" ").strip
      started_at = Process.clock_gettime(Process::CLOCK_MONOTONIC)

      Jekyll.logger.info "Jekyll-Pagefind:", "Running Pagefind..."
      _stdout, stderr, status = Open3.capture3(full_command)

      if status.success?
        elapsed = Process.clock_gettime(Process::CLOCK_MONOTONIC) - started_at
        Jekyll.logger.info "Jekyll-Pagefind:", format("Done in %.2fs", elapsed)
      else
        Jekyll.logger.error "Jekyll-Pagefind Error:", stderr
        raise "Pagefind binary exited with non-zero status code: #{status.exitstatus}"
      end
    end
  end
end

# Hook ensures Jekyll is entirely done writing HTML pages to disk
Jekyll::Hooks.register :site, :post_write do |site|
  # Parse plugin settings out of site.config
  custom_flags = Jekyll::Pagefind.build_cli_arguments(site.config)
  # Run Pagefind with the compiled flags
  Jekyll::Pagefind.run_pagefind(site.dest, custom_flags)
end
