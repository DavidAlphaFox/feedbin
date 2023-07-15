module FixFeeds
  class SuggestionComponent < ApplicationComponent

    def initialize(replaceable:, source:, redirect:, behavior: :remote)
      @replaceable = replaceable
      @source = source
      @behavior = behavior
      @redirect = redirect
    end

    def template
      div(class: "items-start") do
        div class: "flex gap-4" do
          timeline_header
          header
        end

        form
      end
    end

    def header
      div class: "p-4 pt-0 grow" do
        render App::FeedComponent do |feed|
          feed.icon do
            helpers.favicon_with_record(@source.favicon, host: @source.host, generated: true)
          end
          feed.title do
            div(data_behavior: "user_title", class: "truncate") do
              @replaceable.title
            end
          end
          feed.subhead do
            a(href: @source.feed_url, class: "!text-500 truncate" ) do
              helpers.short_url(@source.feed_url)
            end
          end

          if @source.last_published_entry.respond_to?(:to_formatted_s)
            feed.accessory do
              plain "Last worked: "
              plain @source.last_published_entry&.to_formatted_s(:month_year)
            end
          end
        end
      end
    end

    def form
      form_with(model: @replaceable, url: fix_feed_path(@replaceable), data: @behavior == :remote ? {remote: true, behavior: "disable_on_submit"} : {}) do |form|
        form.hidden_field :redirect_to, value: @redirect
        render Settings::ControlGroupComponent.new class: "group", data: {item_capsule: "true"} do |group|
          @source.discovered_feeds.order(created_at: :asc).each_with_index do |discovered_feed, index|
            group.item do
              div class: "flex gap-4" do
                timeline_item(index)
                div class: "grow" do
                  suggestion(discovered_feed: discovered_feed, checked: index == 0, show_radio: @source.discovered_feeds.count > 1)
                end
              end
            end
          end
        end

        div(class: "flex gap-4 pt-4 justify-end") do
          if @behavior == :remote
            link_to "Ignore", fix_feed_path(@replaceable), method: :delete, remote: true, class: "button-tertiary"
          end

          button(class: "button-secondary", type: "submit") { "Replace" }
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
                  helpers.favicon_with_host(discovered_feed.host, generated: true)
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

    def timeline_item(index)
      div class: "flex flex-col w-[20px] inset-y-0 self-stretch shrink-0" do
        div class: "h-1/2 flex flex-col items-center w-[20px] " do
          div class: "h-full w-[1px] bg-200 #{index != 0 ? "invisible" : ""}" do
          end
          div class: "flex w-[20px] h-[20px] items-start justify-center shrink-0 #{index != 0 ? "invisible" : ""}" do
            render SvgComponent.new("icon-down-arrow", class: "fill-200")
          end
          div class: "h-[8px] w-[8px] relative top-[-5px] bg-green-600 rounded-full shrink-0"
        end
      end
    end

    def timeline_header
      div class: "flex flex-col items-center w-[20px] inset-y-0 self-stretch shrink-0" do
        div class: "flex w-[20px] h-[20px] flex-center mt-[2px] shrink-0" do
          div class: "h-[8px] w-[8px] bg-200 rounded-full"
        end
        div class: "h-full w-[1px] bg-200" do
        end
      end
    end
  end
end
