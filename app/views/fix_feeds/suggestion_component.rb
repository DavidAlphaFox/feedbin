module FixFeeds
  class SuggestionComponent < ApplicationComponent

    def initialize(user:, subscription:)
      @user = user
      @subscription = subscription
    end

    def template
      helpers.present @subscription do |subscription_presenter|
        form_with(model: @subscription, url: fix_feed_path(@subscription)) do |form|
          div(class: "border rounded-lg mb-4") do
            header(subscription_presenter)

            div(class: "p-4") do
              render Settings::ControlGroupComponent.new do |group|
                group.header do
                  plain "Working "
                  plain "Alternative".pluralize(@subscription.feed.discovered_feeds.count)
                end

                div do
                  @subscription.feed.discovered_feeds.each do |discovered_feed|
                    suggestion(discovered_feed, group)
                  end
                end
              end

              div(class: "flex gap-4 pt-4 justify-end") do
                link_to "Ignore", fix_feed_path(@subscription), method: :delete, class: 'button-tertiary'
                button(class: "button") { "Replace" }
              end
            end
          end
        end
      end
    end

    def header(subscription_presenter)
      div(class: "flex items-start gap-2 p-4") do
        div(class: "mt-[2px]") { subscription_presenter.favicon(@subscription.feed) }
        div(class: "flex grow gap-2 space-between items-center") do
          div(class: "grow") do
            p(data_behavior: "user_title", class: "truncate font-bold") do
              @subscription.title
            end
            p(class: "text-sm") do
              a( href: @subscription.feed.feed_url, class: "!text-500 truncate" ) { helpers.short_url(@subscription.feed.feed_url) }
            end
          end

          div(class: "text-sm text-500 flex gap-2 items-center") do
            plain "Broken Since: "
            plain @subscription.feed.last_published_entry.to_formatted_s(:date)
          end
        end
      end
    end

    def suggestion(discovered_feed, group)
      group.item do
        fields_for :discovered_feed, discovered_feed do |discovered_feed_form|
          discovered_feed_form.radio_button(:id, discovered_feed.id, class: "peer", data: {behavior: "auto_submit"})
          discovered_feed_form.label "id_#{discovered_feed.id}", class: "group" do
            render Settings::ControlRowComponent.new do |row|
              row.title do
                discovered_feed.title
              end
              row.description do
                p(class: "text-sm") do
                  a(href: discovered_feed.feed_url, class: "!text-500 truncate" ) { helpers.short_url(discovered_feed.feed_url) }
                end
              end
              row.control { render Form::RadioComponent.new }
            end
          end
        end
      end
    end

  end
end
