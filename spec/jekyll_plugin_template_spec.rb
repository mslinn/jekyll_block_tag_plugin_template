# frozen_string_literal: true

require "fileutils"
require "jekyll"
require "key_value_parser"
require "shellwords"
require_relative "../lib/jekyll_plugin_template"

RSpec.describe(KeyValueParser) do
  it "parses arguments" do
    argv = "param0 param1=value1 param2='value2' param3=\"value3's tricky\" remainder of line".shellsplit
    parser = KeyValueParser.new
    options = parser.parse(argv)
    # puts options.map { |k, v| "#{k} = #{v}" }.join("\n")

    expect(options[:param0]).to eq(true)
    expect(options[:param1]).to eq("value1")
    expect(options[:param2]).to eq("value2")
    expect(options[:param3]).to eq("value3's tricky")
    expect(options[:unknown]).to be_nil

    [:param0, :param1, :param2, :param3].each { |key| options.delete key }
    remainder_of_line = options.keys.join(" ")
    expect(remainder_of_line).to eq("remainder of line")
  end
end
