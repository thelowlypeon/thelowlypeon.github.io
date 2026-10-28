module TagArchives
  # The #tags shown on posts and projects are their `categories`.
  INDEXES = { "posts" => "archive", "projects" => "projects" }.freeze

  class Generator < Jekyll::Generator
    def generate(site)
      tagged = INDEXES.keys.to_h { |collection| [collection, docs_by_tag(site.collections[collection].docs)] }
      taken = site.pages.map(&:url) + site.documents.map(&:url)

      tagged.each do |collection, docs_by_tag|
        docs_by_tag.each do |tag, docs|
          urls = tagged.to_h { |other, tags| [other, (TagPage.url_for(other, tag) if tags.key?(tag))] }
          page = TagPage.new(site, tag, collection, docs, urls)
          if taken.include?(page.url) || taken.include?(page.url.chomp("/"))
            raise Jekyll::Errors::FatalException, "Tag page #{page.url} collides with an existing page"
          end

          site.pages << page
        end
      end
    end

    private

    def docs_by_tag(docs)
      docs.flat_map { |doc| doc.data["categories"] }.uniq.to_h do |tag|
        [tag, docs.select { |doc| doc.data["categories"].include?(tag) }.sort.reverse]
      end
    end
  end

  class TagPage < Jekyll::PageWithoutAFile
    def self.url_for(collection, tag)
      "/#{INDEXES.fetch(collection)}/#{Jekyll::Utils.slugify(tag)}/"
    end

    def initialize(site, tag, collection, docs, urls)
      super(site, site.source, File.join(INDEXES.fetch(collection), Jekyll::Utils.slugify(tag)), "index.html")
      data.merge!(
        "layout" => "tag",
        "tag" => tag,
        "collection" => collection,
        "docs" => docs,
        "tag_urls" => urls,
        "title" => "#{collection.capitalize} tagged ##{tag}",
        "description" => "#{collection.capitalize} tagged ##{tag}."
      )
    end
  end
end
