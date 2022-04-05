# frozen_string_literal: true

require "fileutils"
require_relative "run_this_first_helper"
load "bin/run_this_first"

RSpec.describe(JekyllPluginTemplateModule) do
  it "rename_identifiers" do
    run_this_first = JekyllPluginTemplateModule::RunThisFirst.new(RSpec.configuration.work_dir)
    run_this_first.rename_identifiers("old_variable_name", "new_variable_name")

    gemspec = File.read("old_name.gemspec")
    expect(gemspec).to include <<~END_GEMSPEC
      require_relative "lib/new_name/version"

      Gem::Specification.new do |spec|
        github = "https://github.com/mslinn/new_name"
        spec.name = "new_name"
        spec.version = NewNameVersion::VERSION
      end
    END_GEMSPEC

    version_rb = File.read("old_name/old_name/version.rb")
    expect(version_rb).to include("class NewName")

    old_name_rb = File.read("old_name/old_name/old_name.rb")
    expect(old_name_rb).to include("new_name")
  end

  it "rename_files" do
    run_this_first = JekyllPluginTemplateModule::RunThisFirst.new(RSpec.configuration.work_dir)
    run_this_first.rename_files("old_name", "new_name")
    expect(Dir["."]).to match_array[
      "new_name.gemspec",
      "lib/new_name.rb",
      "lib/new_name/new_name.rb",
      "lib/new_name/version.rb"
    ]
  end
end
