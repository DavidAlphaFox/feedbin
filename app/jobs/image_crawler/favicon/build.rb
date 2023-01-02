module ImageCrawler
  module Favicon
    class Build
      include Sidekiq::Worker
      sidekiq_options retry: false

      def perform(host)
        @host = host

        urls = find_meta_links(["icon", "shortcut icon"]).push(default_favicon_location)
        Pipeline::Find.perform_async("#{SecureRandom.hex}-favicon", "favicon", urls, nil, true)

        urls = find_meta_links(["apple-touch-icon", "apple-touch-icon-precomposed"])
        Pipeline::Find.perform_async("#{SecureRandom.hex}-touch-icon", "favicon", urls, nil, true)
      end

      def find_meta_links(names)
        return [] unless document.present?
        links = document.search(xpath(names))
        links.map do |element|
          url = element["href"]
          url = Addressable::URI.heuristic_parse(url)
          url.scheme = "http"
          unless url.host
            url = URI::HTTP.build(scheme: "http", host: @favicon.host)
            url = url.join(element["href"])
          end
          url.to_s
        end
      end

      def document
        return @document if defined?(@document)
        url = URI::HTTP.build(host: @host)
        homepage = HTTP.timeout(write: 5, connect: 5, read: 5).follow.get(url).to_s
        @document = Nokogiri::HTML5(homepage)
      rescue => exception
        Sidekiq.logger.info "find_meta_links exception=#{exception.inspect} host=#{@host}"
        @document = nil
      end

      def default_favicon_location
        URI::HTTP.build(host: @favicon.host, path: "/favicon.ico")
      end

      def should_update?
        return true if @force
        !updated_recently?
      end

      def updated_recently?
        Icon.provider_favicon.where(provider_id: @host)&.updated_at&.after?(1.hour.ago)
      end

      def xpath(names)
        names.map do |name|
          "//link[not(@mask) and translate(@rel, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = '#{name}']"
        end.join(" | ")
      end


      def perform(url, image)
        Icon.provider_tk.create!(url: image["original_url"], provider_id: host)
        fingerprint = RemoteFile.fingerprint(image["original_url"])
        RemoteFile.create!(
          fingerprint: fingerprint,
          original_url: image["original_url"],
          storage_url: image["processed_url"],
          width: image["width"],
          height: image["height"],
        )
      end
    end
  end
end