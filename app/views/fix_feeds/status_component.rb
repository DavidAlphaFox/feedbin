module FixFeeds
  class StatusComponent < ApplicationComponent

    def initialize(subscriptions:)
      @subscriptions = subscriptions
    end

    def template
      div(class: "flex gap-4 justify-between items-center mb-8", data: {behavior: "status_component"}) do
        div do
          div class: "text-700 font-bold" do
            "Feeds with Errors"
          end
          p(class: "text-sm text-500") do
            plain helpers.number_with_delimiter(@subscriptions.count)
            plain " repairable"
            plain " feed".pluralize(@subscriptions.count)
          end
        end
        link_to "Replace All", helpers.replace_all_fix_feeds_path, class: "button", method: :post
      end
    end
  end
end
