# frozen_string_literal: true

require "jekyll_plugin_logger"

# @author Copyright 2021 {https://www.mslinn.com Michael Slinn}
# Template for Jekyll command plugins.
# @see https://jekyllrb.com/docs/plugins/commands/
class CommandTemplate < Jekyll::Command
  class << self
    @logger = PluginMetaLogger.instance.new_logger(self, PluginMetaLogger.instance.config)

    # @see https://github.com/jekyll/mercenary
    def init_with_program(prog)
      @logger.info { "prog [#{prog.class}] = #{prog}" }
      prog.command(:jekyll_command_template) do |c|
        c.syntax 'jekyll_command_template [options]'
        c.description 'Create a new Jekyll site.'
        c.option 'dest', '-d DEST', 'Where the site should go.'

        c.action do |args, options|
          @logger.debug { "args [#{args.class}] = #{args}" }
          @logger.debug { "options [#{options.class}] = #{options}" }
          Jekyll::Site.new_site_at(options['dest'])
        end
      end
    end
  end
end
