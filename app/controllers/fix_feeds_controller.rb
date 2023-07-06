class FixFeedsController < ApplicationController
  def index
    @user = current_user
    @subscriptions = @user.subscriptions.fix_suggestion_present.includes(feed: [:discovered_feeds])
    view = FixFeeds::IndexView.new(
      user: @user,
      subscriptions: @subscriptions,
    )
    render view, layout: "settings"
  end
end
