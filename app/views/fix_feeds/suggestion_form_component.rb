module FixFeeds
  class SuggestionFormComponent < ApplicationComponent

    def initialize(subscription:, redirect:, include_ignore: true)
      @subscription = subscription
      @include_ignore = include_ignore
      @redirect = redirect
    end

    def template
      form_with(model: @subscription, url: fix_feed_path(@subscription)) do |form|
        form.hidden_field :redirect_to, value: @redirect
        render Settings::ControlGroupComponent.new class: "group", data: {item_capsule: "true"} do |group|
          div do
            @subscription.feed.discovered_feeds.order(created_at: :asc).each_with_index do |discovered_feed, index|
              group.item do
                div class: "flex gap-4" do
                  div class: "flex flex-col w-[20px] inset-y-0 self-stretch shrink-0" do
                    div class: "h-1/2 flex flex-col items-center w-[20px] " do
                      div class: "h-full w-[1px] bg-200 #{index != 0 ? "invisible" : ""}" do
                      end
                      div class: "flex w-[20px] h-[20px] items-start justify-center shrink-0 #{index != 0 ? "invisible" : ""}" do
                        render SvgComponent.new("icon-caret", class: "fill-200")
                      end
                      div class: "h-[8px] w-[8px] relative top-[-5px] bg-green-600 rounded-full shrink-0"
                    end
                  end
                  div class: "grow" do
                    suggestion(discovered_feed: discovered_feed, checked: index == 0, show_radio: @subscription.feed.discovered_feeds.count > 1)
                  end
                end
              end
            end
          end
        end

        div(class: "flex gap-4 pt-4 justify-end") do
          if @include_ignore
            link_to "Ignore", fix_feed_path(@subscription), method: :delete, class: 'button-tertiary'
          end

          button(class: "button-secondary") { "Replace" }
        end
      end
    end

    def suggestion(discovered_feed:, checked:, show_radio:)
      fields_for :discovered_feed, discovered_feed do |discovered_feed_form|
        discovered_feed_form.radio_button(:id, discovered_feed.id, checked: checked, class: "peer")
        discovered_feed_form.label :id, value: discovered_feed.id, class: "group" do
          render Settings::ControlRowComponent.new do |row|
            row.content do
              render App::FeedComponent do |feed|
                feed.icon do
                  helpers.favicon_with_host(discovered_feed.host)
                end
                feed.title do
                  div(class: "font-bold") do
                    discovered_feed.title
                  end
                end
                feed.subhead do
                  a(href: discovered_feed.feed_url, class: "!text-500 truncate" ) { helpers.short_url(discovered_feed.feed_url) }
                end
              end
            end

            row.control do
              if show_radio
                render Form::RadioComponent.new
              end
            end
          end
        end
      end
    end

  end
end
