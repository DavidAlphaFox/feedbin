class FeedImporter
  include Sidekiq::Worker
  sidekiq_options queue: :default_critical, retry: false

  def perform(import_item_id)
    @import_item = ImportItem.find(import_item_id)
    import = @import_item.import
    user = import.user

    feeds = begin
      FeedFinder.feeds(@import_item.details[:xml_url], import_mode: true)
    rescue => exception
      @import_item.update(status: :failed, error_class: exception.class.name, error_message: exception.message)
      []
    end

    if feeds.present?
      feed = feeds.first
      user.subscriptions.create_with(title: @import_item.details[:title]).find_or_create_by(feed: feed)
      feed.tag(@import_item.details[:tag], user, false) if @import_item.details[:tag]
      @import_item.complete!
    else
      FaviconCrawler::Finder.perform_async(@import_item.host)
      discover_feeds
      @import_item.failed!
    end

    import.with_lock do
      unless import.import_items.where(status: :pending).exists?
        import.update(complete: true)
      end
    end
  rescue ActiveRecord::RecordNotUnique
    @import_item.complete!
  rescue => exception
    @import_item.failed!
    raise exception
  end

  def discover_feeds
    return unless @import_item.site_url.present?

    urls = begin
      FeedFinder.new(@import_item.site_url).find_options
    end

    hosts = Set.new
    urls.each do |url|
      next unless option = FeedFixer.new.validate_option(url)

      discovery = DiscoveredFeed.find_or_create_by(
        site_url: @import_item.site_url,
        feed_url: option.feed_url
      )

      discovery.update(
        title: option.title,
        verified_at: Time.now
      )

      hosts.add(discovery.host)
    end

    hosts.each { FaviconCrawler::Finder.perform_async(_1) }
  end
end
