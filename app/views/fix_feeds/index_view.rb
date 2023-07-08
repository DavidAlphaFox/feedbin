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

      p(class: "text-500 mb-4") do
        "Feedbin is unable to download these feeds. However it looks like there may working alternatives available. You can review the options below."
      end

      @subscriptions.each do |subscription|
        render SuggestionComponent.new(user: @user, subscription: subscription)
      end
    end
  end
end
