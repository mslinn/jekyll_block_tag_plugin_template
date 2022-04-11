# frozen_string_literal: true

require "nokogiri"
require "talk_like_a_pirate"

module JekyllHookExamples
  def modify_output
    proc do |webpage|
      webpage.output.gsub!('Jekyll', 'Awesome Jekyll')
    end
  end

  def pirate_translator
    proc do |webpage|
      html = Nokogiri.HTML(webpage.output)
      html.css("p").each do |node|
        node.content = TalkLikeAPirate.translate(node.content)
      end
      webpage.output = html
    end
  end

  module_function :modify_output, :pirate_translator

  # Uncomment the following lines, rebuild the plugin and view http://localhost:4444/
  # to see these hooks in action:
  # Jekyll::Hooks.register(:documents, :post_render, &modify_output)
  # Jekyll::Hooks.register(:pages, :post_render, &modify_output)

  Jekyll::Hooks.register(:documents, :post_render, &pirate_translator)
  Jekyll::Hooks.register(:pages, :post_render, &pirate_translator)
end
