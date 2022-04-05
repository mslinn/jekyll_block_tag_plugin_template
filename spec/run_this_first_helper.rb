# frozen_string_literal: true

load "bin/run_this_first"

RSpec.configure do |config|
  config.add_setting :work_dir
  config.work_dir = "/tmp/jekyll_plugin_template"

  config.after(:suite) do
    FileUtils.rm_rf(config.work_dir)
  end
  config.before(:suite) do
    FileUtils.cp_r "spec/run_this_first_data", config.work_dir, :verbose => true
  end
  config.filter_run :focus
  config.order = "random"
  config.run_all_when_everything_filtered = true

  # See https://relishapp.com/rspec/rspec-core/docs/command-line/only-failures
  config.example_status_persistence_file_path = "spec/first_status_persistence.txt"
end
