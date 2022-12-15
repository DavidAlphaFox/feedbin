module ImageCrawler
  class CacheIcon
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(url, image = nil)
      @fingerprint, @url = url.split("-")
      @image = image
      @image ? receive : schedule
    end

    def schedule
      unless Icon.where(fingerprint: @fingerprint).exists?
        FindImage.perform_async("#{@fingerprint}-#{@fingerprint}", "icon", [@url])
      end
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
