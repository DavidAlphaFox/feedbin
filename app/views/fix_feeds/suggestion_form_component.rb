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
        render Settings::ControlGroupComponent.new do |group|
          # group.header do
          #   plain "Working "
          #   plain "Alternative".pluralize(@subscription.feed.discovered_feeds.count)
          # end

          div do
            @subscription.feed.discovered_feeds.order(created_at: :asc).each_with_index do |discovered_feed, index|
              suggestion(
                discovered_feed: discovered_feed,
                group: group,
                checked: index == 0,
                show_radio: @subscription.feed.discovered_feeds.count > 1
              )
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

    def suggestion(discovered_feed:, group:, checked:, show_radio:)
      group.item do
        fields_for :discovered_feed, discovered_feed do |discovered_feed_form|
          discovered_feed_form.radio_button(:id, discovered_feed.id, checked: checked, class: "peer")
          discovered_feed_form.label :id, value: discovered_feed.id, class: "group" do
            render Settings::ControlRowComponent.new do |row|
              row.title do
                discovered_feed.title
              end
              row.description do
                p(class: "text-sm") do
                  a(href: discovered_feed.feed_url, class: "!text-500 truncate" ) { helpers.short_url(discovered_feed.feed_url) }
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
end
