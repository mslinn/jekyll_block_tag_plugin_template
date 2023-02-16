require 'jekyll_plugin_support'

module JekyllPluginBlockTagTemplate
  PLUGIN_NAME = 'block_tag_template'
end

# This is the module-level description.
#
# @example Heading for this example
#   Describe what this example does
#   {% block_tag_template 'parameter' %}
#     Hello, world!
#   {% endblock_tag_template %}
#
# The Jekyll log level defaults to :info, which means all the Jekyll.logger statements below will not generate output.
# You can control the log level when you start Jekyll.
# To set the log level to :debug, write an entery into _config.yml, like this:
# plugin_loggers:
#   MyBlock: debug

module JekyllBlockTagPlugin
  # This class implements the Jekyll block tag functionality
  class MyBlock < JekyllSupport::JekyllBlock
    include JekyllPluginTemplateVersion

    # See https://github.com/Shopify/liquid/wiki/Liquid-for-Programmers#create-your-own-tags
    # @param tag_name [String] the name of the tag, which we already know.
    # @param argument_string [String] the arguments from the tag, as a single string.
    # @param _parse_context [Liquid::ParseContext] hash that stores Liquid options.
    #        By default it has two keys: :locale and :line_numbers, the first is a Liquid::I18n object, and the second,
    #        a boolean parameter that determines if error messages should display the line number the error occurred.
    #        This argument is used mostly to display localized error messages on Liquid built-in Tags and Filters.
    #        See https://github.com/Shopify/liquid/wiki/Liquid-for-Programmers#create-your-own-tags
    # @return [void]
    def initialize(tag_name, argument_string, parse_context) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
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

      @logger.debug do
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

    REJECTED_ATTRIBUTES = %w[content excerpt next previous].freeze

    # Method prescribed by the Jekyll plugin lifecycle.
    # @param liquid_context [Liquid::Context]
    # @return [String]
    def render(liquid_context) # rubocop:disable Metrics/AbcSize
      content = super # This underdocumented assignment returns the text within the block.

      @site = liquid_context.registers[:site]
      @config = @site.config
      @mode = @config.dig('env', 'JEKYLL_ENV') || 'development'

      # variables defined in pages are stored as hash values in liquid_context
      _assigned_page_variable = liquid_context['assigned_page_variable']

      # The names of front matter variables are hash keys for @page
      @page = liquid_context.registers[:page] # @page is a Jekyll::Drops::DocumentDrop
      # layout = @page['layout']

      @envs = liquid_context.environments.first
      @layout_hash = @envs['layout']

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

      # Compute the return value of this Jekyll tag
      <<~HEREDOC
        <p style='color: green; background-color: yellow; padding: 1em; border: solid thin grey;'>
          #{content} #{@param1}
        </p>
      HEREDOC
    end

    JekyllPluginHelper.register(self, JekyllPluginBlockTagTemplate::PLUGIN_NAME)
  end
end
