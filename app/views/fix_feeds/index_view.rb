module FixFeeds
  class IndexView < ApplicationView

    def initialize(user:, subscriptions:)
      @user = user
      @subscriptions = subscriptions
    end

    def template
      render Settings::H1Component.new do
        "Fix Feeds"
      end

      p(class: "text-500 mb-8") do
        if @subscriptions.present?
          "Feedbin is unable to download these feeds. However it looks like there may working alternatives available. You can review the options below."
        else
          "If Feedbin finds working alternatives to feeds that have stopped updating, they will show up here."
        end
      end

      if @subscriptions.present?
        div(class: "flex gap-4 justify-between items-center mb-8") do
          p(class: "text-sm text-500") do
            plain helpers.number_with_delimiter(@subscriptions.count)
            plain " repairable"
            plain " feed".pluralize(@subscriptions.count)
          end
          link_to "Replace All", helpers.replace_all_fix_feeds_path, class: "button", method: :post
        end
      end

      @subscriptions.each do |subscription|
        render SuggestionComponent.new(subscription: subscription)
      end
    end
  end
end
