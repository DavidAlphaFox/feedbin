module Settings
  module ImportItems
    class ImportItemComponent < ApplicationComponent

      def initialize(import_item:)
        @import_item = import_item
      end

      def template
        div class: "opacity-100 transition", id: helpers.dom_id(@import_item, :fixable) do
          render Settings::ExpandableComponent.new class: "mb-4", data: { capsule: "true" } do |expandable|
            expandable.description do
              div class: "p-4" do
                render App::FeedComponent do |feed|
                  feed.icon do
                    helpers.favicon_with_record(@import_item.favicon, host: @import_item.host, generated: true)
                  end
                  feed.title do
                    link_to @import_item.details[:title] || "Untitled", @import_item.details[:html_url], target: "_blank", class: "!text-600"
                  end
                  feed.subhead do
                    a(href: @import_item.details[:xml_url], class: "!text-500 truncate" ) do
                      helpers.short_url(@import_item.details[:xml_url])
                    end
                  end
                  feed.accessory do
                    span(class: "text-red-600") { @import_item.human_error }
                  end
                end
              end

              if helpers.current_user.setting_on?(:fix_feeds_flag) && @import_item.discovered_feeds.present?
                div class: "border-t p-4" do
                  div(class: "flex gap-2") do
                    div(class: "pt-1") do
                      render SvgComponent.new "menu-icon-fix-feeds", class: "fill-700"
                    end
                    div do
                      p do
                        "Fixable Feed"
                      end
                      p(class: "text-500 text-sm") do
                        "Feedbin was unable to import this feed. However, it looks like there may be a working alternative available."
                      end
                      div(class: "mt-4") do
                        render FixFeeds::SuggestionComponent.new(replaceable: @import_item, source: @import_item, redirect: helpers.fix_feeds_url, include_ignore: false)
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end