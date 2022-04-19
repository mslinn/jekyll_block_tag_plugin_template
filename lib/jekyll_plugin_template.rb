# frozen_string_literal: true

require "jekyll"
require "jekyll_plugin_logger"
require_relative "jekyll_plugin_template/version"
require_relative "jekyll_block_tag_plugin"
require_relative "jekyll_filter_template"
require_relative "jekyll_tag_plugin"
require_relative "jekyll_hooks"
require_relative "jekyll_hook_examples"
require_relative "category_index_generator"

module JekyllPluginTemplate
  include JekyllBlockTagPlugin
  include JekyllFilterTemplate
  include JekyllTagPlugin
  include JekyllPluginHooks
  include JekyllHookExamples
  include CategoryIndexGenerator
end
