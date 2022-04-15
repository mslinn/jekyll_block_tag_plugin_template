# frozen_string_literal: true

require "jekyll"
require "jekyll_plugin_logger"
require_relative "jekyll_plugin_template/version"
require_relative "jekyll_block_tag_plugin"
require_relative "jekyll_hooks"
require_relative "jekyll_hook_examples"
require_relative "jekyll_tag_plugin"

module JekyllPluginTemplate
  include JekyllPluginHooks
  include JekyllHookExamples
  include JekyllBlockTagPlugin
  include JekyllTagPlugin
end
