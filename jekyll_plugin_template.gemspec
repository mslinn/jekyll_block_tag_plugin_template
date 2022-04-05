# frozen_string_literal: true

require_relative "lib/jekyll_plugin_template/version"

# rubocop:disable Metrics/BlockLength
Gem::Specification.new do |spec|
  github = "https://github.com/mslinn/jekyll_plugin_template"

  spec.authors = ["Firstname Lastname"]
  spec.bindir = "exe"
  spec.description = <<~END_OF_DESC
    Expand on what spec.summary says.
  END_OF_DESC
  spec.email = ["email@email.com"]

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir[".rubocop.yml", "LICENSE.*", "Rakefile", "{lib,spec}/**/*", "*.gemspec", "*.md"]

  spec.homepage = "https://www.mslinn.com/blog/2020/12/30/jekyll-plugin-template-collection.html"
  spec.license = "MIT"
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
  spec.add_dependency "os"
  spec.add_dependency "shellwords"
  spec.add_dependency "tty-prompt"

  spec.add_development_dependency "debase"
  # spec.add_development_dependency "rubocop-jekyll"
  # spec.add_development_dependency "rubocop-rake"
  # spec.add_development_dependency "rubocop-rspec"
  spec.add_development_dependency "ruby-debug-ide"
end
# rubocop:enable Metrics/BlockLength
