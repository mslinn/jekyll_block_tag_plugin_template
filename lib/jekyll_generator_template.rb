# frozen_string_literal: true

require_relative "jekyll_plugin_template/version"

module JekyllGeneneratorPluginName
  PLUGIN_NAME = "block_tag_template"
end

module JekyllGeneneratorPlugin
  class GeneratorTemplate < Jekyll::Generator
    priority :normal

    # Method prescribed by the Jekyll plugin lifecycle.
    # @param _site [Jekyll.Site] Automatically provided by Jekyll plugin mechanism
    # @return [void]
    def generate(_site)
      @logger = PluginMetaLogger.instance.new_logger(self, PluginMetaLogger.instance.config)

      return unless webpage.data['pirate_talk']

      html = Nokogiri.HTML(webpage.output)
      html.css("p").each do |node|
        node.content = TalkLikeAPirate.translate(node.content)
      end
      webpage.output = html
    end

    private

    def to_pirate

    end
  end

  PluginMetaLogger.instance.logger.info { "Loaded #{JekyllGeneneratorPluginName::PLUGIN_NAME} v#{JekyllPluginTemplateVersion::VERSION} plugin." }
end
