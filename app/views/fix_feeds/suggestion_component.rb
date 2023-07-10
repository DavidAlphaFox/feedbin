module FixFeeds
  class SuggestionComponent < ApplicationComponent

    def initialize(subscription:)
      @subscription = subscription
    end

    def template
      helpers.present @subscription do |subscription_presenter|
        div(class: "border rounded-lg mb-8") do
          header(subscription_presenter)

          div(class: "p-4") do
            render SuggestionFormComponent.new(subscription: @subscription, redirect: helpers.fix_feeds_url)
          end
        end
      end
    end

    def header(subscription_presenter)
      div(class: "flex items-start gap-2 p-4 pb-0") do
        div(class: "mt-[2px]") do
          subscription_presenter.favicon(@subscription.feed)
        end
        div(class: "flex grow gap-2 space-between items-center") do
          div(class: "grow") do
            p(data_behavior: "user_title", class: "truncate font-bold") do
              @subscription.title
            end
            p(class: "text-sm") do
              a( href: @subscription.feed.feed_url, class: "!text-500 truncate" ) { helpers.short_url(@subscription.feed.feed_url) }
            end
          end

          div(class: "text-sm text-500 gap-2 items-center tw-hidden sm:flex") do
            plain "Last worked: "
            plain @subscription.feed.last_published_entry.to_formatted_s(:month_year)
          end
        end
      end
    end
  end
end
