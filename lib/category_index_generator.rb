# frozen_string_literal: true

# Taken from https://jekyllrb.com/docs/plugins/generators/ with necessary changes so it works, and unnecessary code removed
module SamplePlugin
  # TODO Where do the pages get written?
  # Creates an index page for each catagory
  class CategoryIndexGenerator < Jekyll::Generator
    # safe true

    def generate(site)
      site.categories.each do |category, posts|
        site.pages << CategoryPage.new(site, category, posts)
      end
    end
  end

  # Subclass of `Jekyll::Page` with custom method definitions.
  # See https://github.com/jekyll/jekyll/blob/master/lib/jekyll/page.rb
  class CategoryPage < Jekyll::Page
    def initialize(site, category, posts) # rubocop:disable Metrics/MethodLength
      @site = site             # the current site instance.
      @base = site.source      # path to the source directory.
      @dir  = category         # the directory the page will reside in.

      # All pages have the same filename, so define attributes straight away.
      @basename = 'index'      # filename without the extension.
      @ext      = '.html'      # the extension.
      @name     = 'index.html' # basically @basename + @ext.

      super(site, @base, @dir, @name)

      # Initialize data hash with a key pointing to all posts under current category.
      # This allows accessing the list in a template via `page.linked_docs`.
      @data = {
        'linked_docs' => posts,
      }

      # Look up front matter defaults scoped to type `categories`, if given key
      # doesn't exist in the `data` hash.
      data.default_proc = proc do |_, key|
        site.frontmatter_defaults.find(relative_path, :categories, key)
      end
    end

    # Placeholders that are used in constructing page URL.
    def url_placeholders
      {
        category: @dir,
        basename: basename,
        output_ext: output_ext
      }
    end
  end

  PluginMetaLogger.instance.logger.info { "Loaded CategoryIndexGenerator v#{JekyllPluginTemplateVersion::VERSION} plugin." }
end
