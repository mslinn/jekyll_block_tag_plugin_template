# frozen_string_literal: true

require_relative "lib/jekyll_plugin_template/version"

Gem::Specification.new do |spec|
  github = "https://github.com/mslinn/jekyll_plugin_template"

  spec.authors = ["Firstname Lastname"]
  spec.bindir = "bin"
  spec.description = <<~END_OF_DESC
    Expand on what spec.summary says.
  END_OF_DESC
  spec.email = ["email@email.com"]
  spec.executables = ['command_template']

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir[".rubocop.yml", "LICENSE.*", "Rakefile", "{lib,spec}/**/*", "*.gemspec", "*.md"]

  spec.homepage = "https://www.mslinn.com/blog/2020/12/30/jekyll-plugin-template-collection.html"
  spec.license = "CC0-1.0"
  spec.metadata = {
    "allowed_push_host" => "https://rubygems.org",
    "bug_tracker_uri"   => "#{github}/issues",
    "changelog_uri"     => "#{github}/CHANGELOG.md",
    "homepage_uri"      => spec.homepage,
    "source_code_uri"   => github,
  }
  spec.name = "jekyll_plugin_template"
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.6.0"
  spec.summary = "Write a short summary; RubyGems requires one."
  spec.version = JekyllPluginTemplateVersion::VERSION

  spec.add_dependency "jekyll", ">= 3.5.0"
  spec.add_dependency "jekyll_plugin_logger"
  spec.add_dependency "key-value-parser"
  spec.add_dependency "git"
  spec.add_dependency "nokogiri"
  spec.add_dependency "os"
  spec.add_dependency "shellwords"
  spec.add_dependency "talk_like_a_pirate", ">= 0.2.2"
  spec.add_dependency "tty-prompt"

  spec.add_development_dependency "debase"
  spec.add_development_dependency "ruby-debug-ide"
end
