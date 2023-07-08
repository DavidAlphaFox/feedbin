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

  def update
    @user = current_user
    subscription = @user.subscriptions.find(params[:id])
    discovered_feed = DiscoveredFeed.find(params[:discovered_feed][:id])

    new_feed = FeedFinder.feeds(discovered_feed.feed_url)&.first
    old_feed = subscription.feed

    if new_feed
      if existing = @user.subscriptions.where(feed: new_feed).take
        subscription.destroy
      else
        subscription.update(feed: new_feed, fix_status: Subscription.fix_statuses[:none])
      end

      @user.taggings.where(feed: old_feed).update(feed: new_feed)
      @user.actions.where(all_feeds: true).each { _1.save }
      @user.actions.where(":feed_id = ANY(feed_ids)", feed_id: old_feed.id.to_s).each do |action|
        new_feeds = action.feed_ids - [old_feed.id.to_s]
        new_feeds.push(new_feed.id.to_s)
        action.update(feed_ids: new_feeds)
      end
    else
      @error = true
    end

    redirect_to fix_feeds_url
  end

  def destroy
    subscription = @user.subscriptions.find(params[:id])
    subscription.fix_suggestion_ignored!
    redirect_to fix_feeds_url
  end
end
