# frozen_string_literal: true

module JekyllHookExamples
  def modify_output
    proc do |webpage|
      webpage.output.gsub!('Jekyll', 'Awesome Jekyll')
    end
  end

  module_function :modify_output

  # Uncomment the following lines, rebuild the plugin and view http://localhost:4444/
  # to see these hooks in action:
  # Jekyll::Hooks.register(:documents, :post_render, &modify_output)
  # Jekyll::Hooks.register(:pages, :post_render, &modify_output)
end
