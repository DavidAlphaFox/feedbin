module Icons
  module V1
    class IconsController < ApplicationController
      skip_before_action :authorize

      AUTH_HEADER     = "X-Pull"
      URL_HEADER      = "X-Image-URL".freeze
      SIZE_HEADER     = "X-Image-Size".freeze
      PROXY_PATH      = "/remote"
      SENDFILE_HEADER = Rails.application.config.action_dispatch.x_sendfile_header

      def show
        size = params[:size]
        signature = params[:signature]
        url = Icon.decode(params[:url])

        unless ENV["ICON_AUTH_KEY"] == request.headers[AUTH_HEADER]
          head :not_found and return
        end

        unless Icon.signature_valid?(params[:signature], url)
          head :not_found and return
        end

        unless url.start_with?("http")
          head :not_found and return
        end

        unless Icon::BUCKET
          redirect_to url and return
        end

        size = %w(32 64 128 200 400).include?(params[:size]) ? params[:size] : "400"
        response.headers[SIZE_HEADER] = size
        response.headers[SENDFILE_HEADER] = PROXY_PATH

        if icon = Icon.find_by(fingerprint: Icon.fingerprint(url))
          response.headers[URL_HEADER] = icon.storage_url
        else
          response.headers[URL_HEADER] = camo_url
          ImageCrawler::CacheIcon.schedule(url)
        end

        head :ok
      end

      private

      def camo_url
        "#{ENV["CAMO_HOST"]}/#{params[:signature]}/#{params[:url]}"
      end
    end
  end
end