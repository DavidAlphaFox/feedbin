module ImageCrawler
  class CacheIcon
    include Sidekiq::Worker
    sidekiq_options retry: false

    def self.schedule(url)
      fingerprint = Icon.fingerprint(url)
      FindImage.perform_async("#{fingerprint}-icon", "icon", [url])
    end

    def perform(url, image = nil)
      @fingerprint = url.split("-").first
      @image = image
      receive
    end

    def receive
      Icon.create!(
        fingerprint: @fingerprint,
        original_url: @image["original_url"],
        storage_url: @image["processed_url"]
      )
    end
  end
end
