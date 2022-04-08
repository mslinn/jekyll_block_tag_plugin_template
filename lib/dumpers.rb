# frozen_string_literal: true

module Dumpers
  # @param msg[String]
  # @param page[Jekyll:Page] https://github.com/jekyll/jekyll/blob/master/lib/jekyll/page.rb
  #   attr_writer :dir
  #   attr_accessor :basename, :content, :data, :ext, :name, :output, :pager, :site
  def dump_page(logger, msg, page)
    attrs = [:@basename, :@ext, :@name, :@output, :@pager]
    attributes = attrs.map { |attr| "    #{attr.to_s.delete_prefix("@")} = #{page.instance_variable_get(attr)}" }
    # site = page.site available if you need it
    data = page.data.map { |k, v| "    #{k} = #{v}" }
    logger.info do
      <<~END_PAGE
        #{msg}\n  page:
        #{attributes.join("\n")}
            content not dumped because it would likely be too long
            site not dumped also
          data:
        #{data.join("\n")}
      END_PAGE
    end
  end

  # Typical output:
  #   INFO SiteHooks: Jekyll::Hooks.register(:site, :pre_render) payload =
  #     content =
  #     paginator =
  #     jekyll = Jekyll::Drops::JekyllDrop
  #     layout =
  #     site = Jekyll::Drops::SiteDrop
  #     highlighter_prefix =
  #     page =
  #     highlighter_suffix =
  #
  # @param msg[String]
  # @param payload[Jekyll::UnifiedPayloadDrop]
  def dump_payload(logger, msg, payload)
    x = payload.map { |k, v| "  #{k} = #{v}" }
    logger.info { "#{msg} payload = \n" + x.join("\n") }
  end

  # @param msg[String]
  # @param site[Jekyll::Site] https://github.com/jekyll/jekyll/blob/master/lib/jekyll/site.rb
  #   attr_accessor :baseurl, :converters, :data, :drafts, :exclude,
  #     :file_read_opts, :future, :gems, :generators, :highlighter,
  #     :include, :inclusions, :keep_files, :layouts, :limit_posts,
  #     :lsi, :pages, :permalink_style, :plugin_manager, :plugins,
  #     :reader, :safe, :show_drafts, :static_files, :theme, :time,
  #     :unpublished
  #   attr_reader :cache_dir, :config, :dest, :filter_cache, :includes_load_paths,
  #     :liquid_renderer, :profiler, :regenerator, :source
  def dump_site(logger, msg, site) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
    logger.info do
      <<~END_INFO
        #{msg} site
        site is of type #{site.class}
        site.time = #{site.time}
      END_INFO
    end
    env = site.config['env']
    if env
      mode = env['JEKYLL_ENV']
      logger.info { "site.config['env']['JEKYLL_ENV'] = #{mode}" }
    else
      logger.info { "site.config['env'] is undefined" }
    end
    site.collections.each do |key, _|
      logger.info { "site.collections.#{key}" }
    end

    # key env contains all environment variables, quite verbose so output is reduced to just the "env" key
    logger.info { "site.config has #{site.config.length} entries:" }
    site.config.sort.each { |key, value| logger.info { "  site.config.#{key} = '#{value}'" unless key == "env" } }

    logger.info { "site.data has #{site.data.length} entries:" }
    site.data.sort.each { |key, value| logger.info { "  site.data.#{key} = '#{value}'" } }

    logger.info { "site.documents has #{site.documents.length} entries." }
    site.documents.each { |key, _value| logger.info "site.documents.#{key}" }

    logger.info do
      <<~END_INFO
        site.keep_files has #{site.keep_files.length} entries.
        site.keep_files: #{site.keep_files.sort}
        site.pages has #{site.pages.length} entries.
      END_INFO
    end

    site.pages.each { |key, _value| logger.info "site.pages.#{key}" }

    logger.info { "site.posts has #{site.posts.docs.length} entries." }
    site.posts.docs.each { |key, _value| logger.info "site.posts.docs.#{key}" }

    logger.info { "site.tags has #{site.tags.length} entries." }
    site.tags.sort.each { |key, value| logger.info { "site.tags.#{key} = '#{value}'" } }
  end

  module_function :dump_page, :dump_payload, :dump_site
end
