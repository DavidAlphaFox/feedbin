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
        render StatusComponent.new(subscriptions: @subscriptions)
      end

      @subscriptions.each do |subscription|
        div class: "border rounded-lg mb-4 p-4 opacity-100 transition", id: helpers.dom_id(subscription, :fixable) do
          render SuggestionComponent.new(subscription: subscription, redirect: helpers.fix_feeds_url)
        end
      end
    end
  end
end
