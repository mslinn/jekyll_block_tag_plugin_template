# frozen_string_literal: true

require "jekyll_plugin_logger"

# @author Copyright 2020 {https://www.mslinn.com Michael Slinn}
# Template for Jekyll filters.
module JekyllFilterTemplate
  class << self
    attr_accessor :logger
  end
  self.logger = PluginMetaLogger.instance.new_logger(self, PluginMetaLogger.instance.config)

  # This Jekyll filter returns the URL to search Google for the contents of the input string.
  # @param input_string [String].
  # @return [String] empty string if input_string has no contents except whitespace.
  # @example Use.
  #   {{ "joy" | my_filter_template }} => <a href='https://www.google.com/search?q=joy' target='_blank' rel='nofollow'>joy</a>
  def my_filter_template(input_string)
    # @context[Liquid::Context] is available here to look up variables defined in front matter, templates, page, etc.

    JekyllFilterTemplate.logger.debug do
      "Defined filters are: " + self.class # rubocop:disable Style/StringConcatenation
                                    .class_variable_get('@@global_strainer')
                                    .filter_methods.instance_variable_get('@hash')
                                    .map { |k, _v| k }
                                    .sort
    end

    input_string.strip!
    JekyllFilterTemplate.logger.debug "input_string=#{input_string}"
    if input_string.empty?
      ""
    else
      "<a href='https://www.google.com/search?q=#{input_string}' target='_blank' rel='nofollow'>#{input_string}</a>"
    end
  end

  PluginMetaLogger.instance.logger.info { "Loaded JekyllFilterTemplate v#{JekyllPluginTemplateVersion::VERSION} plugin." }
end

Liquid::Template.register_filter(JekyllFilterTemplate)
