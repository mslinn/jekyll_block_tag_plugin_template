# frozen_string_literal: true

module Dumpers
  # See https://github.com/jekyll/jekyll/blob/master/lib/jekyll/collection.rb
  #   attr_reader :site, :label, :metadata
  #   attr_writer :docs
  #   Metadata is a hash with at least these keys: output[Boolean], permalink[String]
  #   selected methods: collection_dir, directory, entries, exists?, files, filtered_entries, relative_directory
  def collection_as_string(collection, indent_spaces)
    indent = " " * indent_spaces
    result = <<~END_COLLECTION
      '#{collection.label}' collection within '#{collection.relative_directory}' subdirectory
        #{indent}Directory: #{collection.directory}
        #{indent}Does the directory exist and is it not a symlink if in safe mode? #{collection.exists?}
        #{indent}Collection_dir: #{collection.collection_dir}
        #{indent}Metadata: #{collection.metadata}
        #{indent}Static files: #{collection.files}
        #{indent}Filtered entries: #{collection.filtered_entries}
    END_COLLECTION
    result.chomp
  end

  # @param msg[String]
  # @param document[Jekyll:Document] https://github.com/jekyll/jekyll/blob/master/lib/jekyll/document.rb
  #   attr_reader :path, :extname, :collection, :type; :site is too big to dump here, we already have it anyway
  #   attr_accessor :content, :output
  def dump_document(logger, msg, document)
    attributes = Dumpers.attributes_as_string(document, [:@path, :@extname, :@type])
    logger.info do
      <<~END_DOC
        #{msg}\n  page:
        #{attributes.join("\n")}
            collection = #{Dumpers.collection_as_string(document.collection, 4)}
            content not dumped because it would likely be too long
            site not dumped also
      END_DOC
    end
  end

  # @param msg[String]
  # @param page[Jekyll:Page] https://github.com/jekyll/jekyll/blob/master/lib/jekyll/page.rb
  #   attr_writer :dir
  #   attr_accessor :basename, :content, :data, :ext, :name, :output, :pager, :site
  def dump_page(logger, msg, page)
    attributes = Dumpers.attributes_as_string(page, [:@basename, :@ext, :@name, :@output, :@pager])
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
  def dump_site(logger, msg, site) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
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

  def attributes_as_string(object, attrs)
    attrs.map { |attr| "    #{attr.to_s.delete_prefix("@")} = #{object.instance_variable_get(attr)}" }
  end

  module_function :attributes_as_string, :collection_as_string, :dump_document, :dump_page, :dump_payload, :dump_site
end
