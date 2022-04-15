# frozen_string_literal: true

require "jekyll_plugin_logger"
require "key_value_parser"
require "shellwords"

module JekyllPluginTagTemplate
  PLUGIN_NAME = "tag_template"
end

# This Jekyll tag plugin creates an emoji of the desired size and alignment.
#
# @example Float Smiley emoji right, sized 3em
#     {% tag_template name='smile' align='right' size='5em' %}
#   The above results in the following HTML:
#     <span style="float: right; font-size: 5em;">&#x1F601;</span>
#
# @example Defaults
#     {% tag_template name='smile' %}
#   The above results in the following HTML:
#     <span style="font-size: 3em;">&#x1F601;</span>
#
# The Jekyll log level defaults to :info, which means all the Jekyll.logger statements below will not generate output.
# You can control the log level when you start Jekyll.
# To set the log level to :debug, write an entery into _config.yml, like this:
# plugin_loggers:
#   MyTag: debug
module JekyllTagPlugin
  # This class implements the Jekyll tag functionality
  class MyTag < Liquid::Tag
    # Supported emojis (GitHub symbol, hex code) - see https://gist.github.com/rxaviers/7360908 and
    # https://www.quackit.com/character_sets/emoji/emoji_v3.0/unicode_emoji_v3.0_characters_all.cfm
    @@emojis = {
      'angry'      => '&#x1F620;',
      'boom'       => '&#x1F4A5;', # used when requested emoji is not recognized
      'kiss'       => '&#x1F619;',
      'scream'     => '&#x1F631;',
      'smiley'     => '&#x1F601;', # default emoji
      'smirk'      => '&#x1F60F;',
      'two_hearts' => '&#x1F495;',
    }

    # @param tag_name [String] is the name of the tag, which we already know.
    # @param argument_string [String] the arguments from the web page.
    # @param tokens [Liquid::ParseContext] tokenized command line
    # @return [void]
    def initialize(tag_name, argument_string, tokens)
      super
      @logger = PluginMetaLogger.instance.new_logger(self, PluginMetaLogger.instance.config)

      argv = Shellwords.split(argument_string) # Scans name/value arguments
      params = KeyValueParser.new.parse(argv) # Extracts key/value pairs, default value for non-existant keys is nil

      @emoji_name  = params[:name]  || "smiley"
      @emoji_align = params[:align] || "inline" # Could be inline, right or left
      @emoji_size  = params[:size]  || "3em"
      @emoji_hex_code = @@emojis[@emoji_name] || @@emojis['boom']
    end

    # Method prescribed by the Jekyll plugin lifecycle.
    # Several variables are created to illustrate how they are made.
    # @param liquid_context [Liquid::Context]
    # @return [String]
    def render(liquid_context) # rubocop:disable Metrics/AbcSize
      @site = liquid_context.registers[:site]
      @config = @site.config
      @mode = @config["env"]["JEKYLL_ENV"] || "development"

      # variables defined in pages are stored as hash values in liquid_context
      _assigned_page_variable = liquid_context['assigned_page_variable']

      # The names of front matter variables are hash keys for @page
      @page = liquid_context.registers[:page] # @page is a Jekyll::Drops::DocumentDrop

      @envs = liquid_context.environments.first
      @layout_hash = @envs['layout']
      # @layout_hash = @page['layout']

      @logger.debug do
        <<~HEREDOC
          liquid_context.scopes=#{liquid_context.scopes}
          mode="#{@mode}"
          page attributes:
            #{@page.sort
                   .reject { |k, _| REJECTED_ATTRIBUTES.include? k }
                   .map { |k, v| "#{k}=#{v}" }
                   .join("\n  ")}
        HEREDOC
      end

      assemble_emoji
    end

    def assemble_emoji
      case @emoji_align
      when "inline"
        align = ""
      when "right"
        align = "float: right; margin-left: 5px;"
      when "left"
        align = "float: left; margin-right: 5px;"
      else
        @logger.error { "Invalid emoji alignment #{@emoji_align}" }
        align = ""
      end
      # Compute the return value of this Jekyll tag
      "<span style='font-size: #{@emoji_size}; #{align}'>#{@emoji_hex_code}</span>"
    end
  end
end

PluginMetaLogger.instance.info { "Loaded #{JekyllPluginTagTemplate::PLUGIN_NAME} v#{JekyllPluginTemplateVersion::VERSION} plugin." }
Liquid::Template.register_tag(JekyllPluginTagTemplate::PLUGIN_NAME, JekyllTagPlugin::MyTag)
