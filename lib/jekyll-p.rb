# frozen_string_literal: true

require_relative "jekyll/pagefind/version"

module Jekyll
  module Pagefind
    # class Jekyll::Pagefind::PagefindGenerator
    class PagefindGenerator < Jekyll::Generator
      safe true
      priority :low

      def generate(site)
        dest_dir = site.dest
        pf_location = site.config["pagefind"] || "pagefind"
        Jekyll::Hooks.register :site, :post_write do |_site|
          command = "./#{pf_location} --site #{dest_dir}"
          system(command)
        end
      end
    end
  end
end
