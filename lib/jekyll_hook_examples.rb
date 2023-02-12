require 'active_support'
require 'active_support/inflector'
require 'confidential_info_redactor'
require 'nokogiri'
require 'talk_like_a_pirate'

# Sample Jekyll Hook plugins
module JekyllHookExamples
  def modify_output
    proc do |webpage|
      webpage.output.gsub!('Jekyll', 'Awesome Jekyll')
    end
  end

  def pirate_translator
    proc do |webpage|
      next unless webpage.data['pirate_talk']

      html = Nokogiri.HTML(webpage.output)
      html.css('p').each do |node|
        node.content = TalkLikeAPirate.translate(node.content)
      end
      webpage.output = html
    end
  end

  def redact
    proc do |webpage|
      next unless webpage.data['redact']

      webpage.content = redact_all webpage.content
    end
  end

  def wrap(text)
    "<span style='background-color: black; color: white; padding: 3pt;'>redacted#{text}</span>"
  end

  # See https://github.com/diasks2/confidential_info_redactor
  # Does not handle HTML markeup properly.
  def redact_all(content)
    tokens = ConfidentialInfoRedactor::Extractor.new.extract(content)
    ConfidentialInfoRedactor::Redactor.new(
      number_text: wrap(' number'), # This redactor is over-eager
      date_text: wrap(' date'),
      token_text: wrap(''),
      tokens: tokens
    ).redact(content)
  end

  module_function :modify_output, :pirate_translator, :redact, :redact_all, :wrap

  # Uncomment the following lines, rebuild the plugin and view http://localhost:4444/
  # to see these hooks in action:
  #
  # Convert 'Jekyll' to 'Awesome Jekyll'
  # Jekyll::Hooks.register(:documents, :post_render, &modify_output)
  # Jekyll::Hooks.register(:pages, :post_render, &modify_output)

  # Convert 'English' to 'Pirate Talk'
  Jekyll::Hooks.register(:documents, :post_render, &pirate_translator)
  Jekyll::Hooks.register(:pages, :post_render, &pirate_translator)

  # Automatically redacts potentially sensitive information in selected pages
  # See https://github.com/diasks2/confidential_info_redactor
  Jekyll::Hooks.register(:documents, :pre_render, &redact)
  Jekyll::Hooks.register(:pages, :pre_render, &redact)

  PluginMetaLogger.instance.logger.info { "Loaded JekyllHookExamples v#{JekyllPluginTemplateVersion::VERSION} plugin." }
end
