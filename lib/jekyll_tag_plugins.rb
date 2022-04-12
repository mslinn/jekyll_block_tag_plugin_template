# frozen_string_literal: true

require "jekyll_plugin_logger"
require "key_value_parser"
require "shellwords"

module JekyllPluginBlockTagTemplate
  PLUGIN_NAME = "block_tag_template"
end

# This is the module-level description.
#
# @example Heading for this example
#   Describe what this example does
#   {% block_tag_template "parameter" %}
#     Hello, world!
#   {% endblock_tag_template %}
#
# The Jekyll log level defaults to :info, which means all the Jekyll.logger statements below will not generate output.
# You can control the log level when you start Jekyll.
# To set the log level to :debug, write an entery into _config.yml, like this:
# plugin_loggers:
#   MyBlock: debug

module JekyllTagPlugin
  # This class implements the Jekyll tag functionality
  class MyBlock < Liquid::Block
    # @param tag_name [String] the name of the tag, which we already know.
    # @param argument_string [String] the arguments from the tag, as a single string.
    # @param _parse_context [Liquid::ParseContext] Liquid variables name/value pairs accessible in the calling page
    #        See https://www.rubydoc.info/gems/liquid/Liquid/ParseContext
    # @return [void]
    def initialize(tag_name, argument_string, parse_context) # rubocop:disable Metrics/MethodLength
      super
      @logger = PluginMetaLogger.instance.new_logger(self, PluginMetaLogger.instance.config)

      @argument_string = argument_string

      argv = Shellwords.split(argument_string) # Scans name/value arguments
      params = KeyValueParser.new.parse(argv) # Extracts key/value pairs, default value for non-existant keys is nil
      @param1 = params[:param1] # Obtain the value of parameter param1
      @param2 = params[:param2]
      @param3 = params[:param3]
      @param4 = params[:param4]
      @param5 = params[:param5]
      @param_x = params[:not_present] # The value of parameters that are present is nil, but displays as the empty string

      @logger.info do
        <<~HEREDOC
          tag_name = '#{tag_name}'
          argument_string = '#{argument_string}'
          @param1 = '#{@param1}'
          @param2 = '#{@param2}'
          @param3 = '#{@param3}'
          @param4 = '#{@param4}'
          @param5 = '#{@param5}'
          @param_x = '#{@param_x}'
          params =
            #{params.map { |k, v| "#{k} = #{v}" }.join("\n  ")}
        HEREDOC
      end
    end

    # Method prescribed by the Jekyll plugin lifecycle.
    # @param context[Liquid::Context]
    # @return [String]
    def render(liquid_context)
      content = super # This underdocumented assignment returns the text within the block.

      @site = liquid_context.registers[:site]
      @config = @site.config
      @mode = @config["env"]["JEKYLL_ENV"] || "development"

      _assigned_page_variable = liquid_context['assigned_page_variable'] # variables defined in pages are stored as hash values in liquid_context
      @page = liquid_context.registers[:page] # names of front matter variables become hash keys for @page

      @envs = liquid_context.environments.first
      @layout_hash = @envs['layout']

      @logger.info do
        <<~HEREDOC
          liquid_context.scopes=#{liquid_context.scopes}
          mode="#{@mode}"
          page attributes:
            #{@page.sort
                   .reject { |k, _| ["content", "next"].include? k }
                   .map { |k, v| "#{k}=#{v}" }
                   .join("\n  ")}
        HEREDOC
      end

      # Compute the return value of this Jekyll tag
      <<~HEREDOC
        <p style="color: green; background-color: yellow; padding: 1em; border: solid thin grey;">
          #{content} #{@param1}
        </p>
      HEREDOC
    end
  end
end

PluginMetaLogger.instance.info { "Loaded #{JekyllPluginBlockTagTemplate::PLUGIN_NAME} v#{JekyllPluginTemplateVersion::VERSION} plugin." }
Liquid::Template.register_tag(JekyllPluginBlockTagTemplate::PLUGIN_NAME, JekyllTagPlugin::MyBlock)
