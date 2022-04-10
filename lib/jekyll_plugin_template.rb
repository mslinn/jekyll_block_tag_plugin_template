# frozen_string_literal: true

require "jekyll_plugin_logger"
require_relative "jekyll_plugin_template/version"
require_relative "jekyll_tag_plugins"
require_relative "jekyll_hooks"
require_relative "jekyll_hook_examples"

module JekyllPluginTemplate
  include JekyllPluginHooks
  include JekyllHookExamples
  include JekyllTagPlugin
end
