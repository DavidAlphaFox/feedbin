module FixFeeds
  class SuggestionComponent < ApplicationComponent

    def initialize(subscription:)
      @subscription = subscription
    end

    def template
      helpers.present @subscription do |subscription_presenter|
        div(class: "border rounded-lg mb-8 items-start p-4 pb-0") do
          div class: "flex gap-4" do
            div class: "flex flex-col items-center w-[20px] inset-y-0 self-stretch shrink-0" do
              div class: "flex w-[20px] h-[20px] flex-center mt-[2px] shrink-0" do
                div class: "h-[8px] w-[8px] bg-200 rounded-full"
              end
              div class: "h-full w-[1px] bg-200" do
              end
            end
            header(subscription_presenter)
          end

          div(class: "pb-4") do
            render SuggestionFormComponent.new(subscription: @subscription, redirect: helpers.fix_feeds_url)
          end
        end
      end
    end

    def header(subscription_presenter)
      div class: "p-4 pt-0 grow" do
        render App::FeedComponent do |feed|
          feed.icon do
            subscription_presenter.favicon(@subscription.feed)
          end
          feed.title do
            div(data_behavior: "user_title", class: "truncate") do
              @subscription.title
            end
          end
          feed.subhead do
            a(href: @subscription.feed.feed_url, class: "!text-500 truncate" ) do
              helpers.short_url(@subscription.feed.feed_url)
            end
          end
          feed.accessory do
            plain "Last worked: "
            plain @subscription.feed.last_published_entry.to_formatted_s(:month_year)
          end
        end
      end
    end
  end
end
