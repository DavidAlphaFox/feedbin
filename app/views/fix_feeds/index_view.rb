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
        "Feedbin has been unable to download these feeds for at least the past two weeks. However it looks like there may be a working alternative. You can review the options below."
      end
      @subscriptions.each do |subscription|
        suggestion(subscription)
      end
    end

    def suggestion(subscription)
      helpers.present subscription do |subscription_presenter|
        div(class: "border rounded-lg mb-4") do
          div(class: "flex items-start gap-2 p-4") do
            div(class: "mt-[2px]") { subscription_presenter.favicon(subscription.feed) }
            div(class: "flex grow gap-2 space-between items-center") do
              div(class: "grow") do
                p(data_behavior: "user_title", class: "truncate font-bold") do
                  subscription.title
                end
                p do
                  a( href: subscription.feed.feed_url, class: "!text-500 text-sm truncate" ) { helpers.short_url(subscription.feed.feed_url) }
                end
              end

              div(class: "text-sm text-500 flex gap-2 items-center") do
                plain "Broken Since: "
                plain subscription.feed.last_published_entry.to_formatted_s(:date)
              end
            end
          end

          div(class: "p-4") do
            p(class: "font-bold mb-4") do
              plain "Working "
              plain "Alternative".pluralize(subscription.feed.discovered_feeds.count)
            end
            div do
              subscription.feed.discovered_feeds.each do |discovered_feed|
                div(class: "border-t flex gap-2 py-4") do
                  div(class: "grow") do
                    p(data_behavior: "user_title", class: "truncate mr-6") do
                      discovered_feed.title
                    end
                    p do
                      a( href: discovered_feed.feed_url, class: "!text-500 text-sm truncate" ) { helpers.short_url(discovered_feed.feed_url) }
                    end
                  end
                end
              end
            end

            div(class: "border-t flex gap-4 pt-4 justify-end") do
              button(class: "button-tertiary") { "Ignore" }
              button(class: "button") { "Replace" }
            end

          end



        end
      end
    end


  end
end
