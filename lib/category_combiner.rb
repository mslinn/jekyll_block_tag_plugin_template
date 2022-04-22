# frozen_string_literal: true

# Testing...
module CategoryCombiner
  # For each catagory, makes a combined page from the collection pages, saves into _site/combined/#{collection.label}.html.
  def combine
    proc do |site, _payload|
      site.collections.each do |_name, collection|
        collection_page = Jekyll::PageWithoutAFile.new(site, site.source, "combined", "#{collection.label}.html")
        collection_page.output = collection.docs.map(&:content).join("\f")
        site.pages << collection_page
      end
    end
  end

  module_function :combine

  Jekyll::Hooks.register(:site, :post_render, &combine)

  PluginMetaLogger.instance.logger.info { "Loaded CategoryGenerator v#{JekyllPluginTemplateVersion::VERSION} plugin." }
end
