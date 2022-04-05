# Jekyll Plugin Gem Customization

The [`bin/run_this_first`](bin/run_this_first) script customizes your new Jekyll plugin gem.
It does the following:
  1) Renames the Jekyll template, including directories, files and contents.
  2) Deletes itself, its tests and its test data.
  3) Does not delete tests for the Jekyll plugin.
  4) Deletes this README.md and renames [`PLUGIN_README.md`](PLUGIN_README.md) to `README.md`.
  5) Initializes a new local git repository and optionally creates a public or private project on GitHub.
  6) Provides scripts for building and testing your new Jekyll plugin gem locally.
  7) Provides settings for Visual Studio Code, Rake, Rubocop and RSpec.

The customized gem is ready to be pushed to `RubyGems.org`, or any other Ruby gem repository, whenever your feel ready.


## About Developing Jekyll Plugins and Ruby Gems
  * [Setting Up a Ruby Development Environment](https://www.mslinn.com/blog/2022/02/12/ruby-setup.html)
  * [Working with Jekyll Plugins as Ruby Gems](https://www.mslinn.com/blog/2022/02/13/jekyll-gem.html)
  * [Making a Jekyll Plugin as a Ruby Gem](https://www.mslinn.com/blog/2022/02/13/jekyll-gem2.html)
  * [Debugging Jekyll Plugins with an IDE](https://www.mslinn.com/blog/2022/02/21/jekyll-debugging.html)
  * [Installing Rubocop As a Development Dependency](https://www.mslinn.com/blog/2022/03/06/rubocop-install.html)
  * [Jekyll Plugin Template Collection](https://www.mslinn.com/blog/2022/03/28/jekyll-plugin-template-collection.html)


## Usage
  1) Clone this repo into a directory called `my_plugin`, or whatever you want to call your plugin.
     ```shell
     $ git clone https://github.com/mslinn/jekyll_plugin_template.git my_plugin
     ```
     Or, if you have forked the project, replace `mslinn` below with your GitHub user id:
     ```shell
     $ git clone git@github.com:mslinn/jekyll_plugin_template.git my_plugin
     ```
  2) Change directory to the new plugin project:
     ```shell
     $ cd my_plugin
     ```
  3) Run the customization script and answer the prompts.
     ```shell
     $ bin/run_this_first
     ```
  4) Open the project in Visual Studio Code and explore the project:
     ```shell
     $ code .
     ```
  5) Build the plugins provided with this template.
     ```shell
     $ rake install:local
     ```
  6) You can now use your new Jekyll plugins in a Jekyll website.

     a) Add the following to your Jekyll website's `Gemfile`.
        The installation script had you rename the plugin template from `jekyll_plugin_template` to a name of your choosing.
        Use that name instead below:
        ```ruby
        group :jekyll_plugins do
          gem 'jekyll_plugin_template'
        end
        ```
     b) Add the following you your Jekyll website's `_config.yml` to set log levels for each type of plugin from the template.
        Customize the log levels as desired:
        ```yaml
        plugin_loggers:
          CleanHook: info
          DocumentHooks: warn
          MyBlock: info
          PageHooks: warn
          PostHooks: warn
          PluginMetaLogger: info
          SiteHooks: info
        ```
  7) Delete the portions of the template that you do not need.
  8) [Debug the Jekyll plugin](https://www.mslinn.com/blog/2022/02/21/jekyll-debugging.html) if required.
  8) [Publish the gem](https://www.mslinn.com/blog/2022/02/13/jekyll-gem2.html#publish) when ready:
     ```shell
     $ bundle exec rake release
     ```


## For More Information
Please see the blog post about this {% href https://mslinn.com/blog/2022/03/28/jekyll-plugin-template-collection.html Jekyll plugin gem template %}.


## Hook Call Order
The Jekyll documentation does not indicate the exact order that each of the 45 hooks gets called.
However, the log output from this template makes that clear.
Following is elided output; I removed duplicate log entries.
All loggers were set to level `info`.
Output will vary, depending on the Jekyll site that is processed and the log levels you set.
`:post_init`, in particular, gets called many times.
```
INFO Module: Jekyll::Hooks.register(:site, :after_reset) invoked.
INFO Module: Jekyll::Hooks.register(:pages, :post_init) invoked.
INFO Module: Jekyll::Hooks.register(:documents, :post_init) invoked.
INFO Module: Jekyll::Hooks.register(:posts, :post_init) invoked.
INFO Module: Jekyll::Hooks.register(:site, :post_read) invoked.
INFO Module: Jekyll::Hooks.register(:pages, :post_init) invoked.
INFO Module: Jekyll::Hooks.register(:site, :pre_render) invoked.
INFO Module: Jekyll::Hooks.register(:pages, :pre_render) invoked.
INFO Module: Jekyll::Hooks.register(:pages, :post_convert) invoked.
INFO Module: Jekyll::Hooks.register(:pages, :post_render) invoked.
INFO Module: Jekyll::Hooks.register(:site, :post_render) invoked.
INFO Module: Jekyll::Hooks.register(:clean, :on_obsolete) invoked for [].
INFO Module: Jekyll::Hooks.register(:pages, :post_write) invoked.
```
