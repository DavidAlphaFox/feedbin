module Views
  module Settings
    module Shared
      class StarredFeedUrl < Phlex::HTML
        include PhlexHelper

        def initialize(user:)
          @user = user
        end

        def template
          if @user.setting_on?(:starred_feed_enabled)
            div class: "truncate" do
              text "Feed URL: "
              link_to helpers.starred_url(@user.starred_token, format: :xml), helpers.starred_url(@user.starred_token, format: :xml)
            end
          else
            text "For "
            link_to helpers.starred_url(@user.starred_token, format: :xml) do
              "integrating with other services"
            end
            text "."
          end
        end
      end
    end
  end
end
