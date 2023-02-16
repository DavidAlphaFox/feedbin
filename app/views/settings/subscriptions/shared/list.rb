module Views
  module Settings
    module Subscriptions
      module Shared
        class List < Phlex::HTML
          include PhlexHelper

          def initialize(subscriptions:, params:)
            @subscriptions = subscriptions
            @params = params
          end

          def template
            div(data_behavior: "subscriptions_list") do
              form_tag helpers.update_multiple_settings_subscriptions_path, method: :patch, autocomplete: "off", class: "group", data: { controller: "toggle-checkboxes", toggle_checkboxes_include_all_visible_value: "false" } do |update_form|
                hidden_field_tag :q, @params[:q]
                div(class: "py-4 flex border-y items-center justify-between") do
                  input(type: "checkbox", class: "peer", data_action: "toggle-checkboxes#toggle", id: "select_all_feeds")
                  label(for: "select_all_feeds", class: "group flex gap-2 items-center") do
                    render Components::Form::Checkbox.new
                    text " Select all "
                  end
                  div(class: "max-w-[250px]") do
                    select_tag(:operation,
                      helpers.options_for_select([["Actions", nil], ["Unsubscribe", "unsubscribe"], ["Show edits on articles", "show_updates"], ["Hide edits on articles", "hide_updates"], ["Mute Feed", "mute"], ["Unmute Feed", "unmute"]]),
                      class: "peer",
                      disabled: true,
                      data: {behavior: "feed_actions", toggle_checkboxes_target: "actions"}
                    )
                  end
                end

                div class: "border-b py-3 block group-data-[toggle-checkboxes-include-all-visible-value=false]:hidden" do
                  check_box_tag "include_all", 1, false, data: { action: "toggle-checkboxes#includeAll", toggle_checkboxes_target: "includeAll" }, class: "peer", id: "include_all_feeds"
                  label( for: "include_all_feeds", class: "group flex gap-2 items-center" ) do
                    render Components::Form::Checkbox.new
                    if @params[:q]
                      text "Include all #{helpers.number_with_delimiter(@subscriptions.total_entries)} #{"subscription".pluralize(@subscriptions.total_entries)} matching this search"
                    else
                      text "Include all #{helpers.number_with_delimiter(@subscriptions.total_entries)} #{"subscription".pluralize(@subscriptions.total_entries)}"
                    end
                  end
                end

                ul(class: "mb-14") do
                  @subscriptions.each do |subscription|
                    render Subscription.new(subscription: subscription)
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
#
#
# div(data_behavior: "subscriptions_list") do
#   form_tag helpers.update_multiple_settings_subscriptions_path, method: :patch, autocomplete: "off", class: "group", data: { controller: "toggle-checkboxes", toggle_checkboxes_include_all_visible_value: "false" } do |update_form|
#     hidden_field_tag :q, params[:q]
#     div(class: "py-4 flex border-y items-center justify-between") do
#       input(type: "checkbox", class: "peer", data_action: "toggle-checkboxes#toggle", id: "select_all_feeds")
#       label(for: "select_all_feeds", class: "group flex gap-2 items-center") do
#         render Components::Form::Switch.new
#         text " Select all "
#       end
#     end
#   end
# end
#
#     if @subscriptions.total_entries > @subscriptions.count
#       div class: "border-b py-3 block group-data-[toggle-checkboxes-include-all-visible-value=false]:hidden" do
#         check_box_tag "include_all", 1, false, data: { action: "toggle-checkboxes#includeAll", toggle_checkboxes_target: "includeAll" }, class: "peer", id: "include_all_feeds"
#         label( for: "include_all_feeds", class: "group flex gap-2 items-center" ) do
#           if params[:q]
#             text " Include all "
#             text number_with_delimiter(@subscriptions.total_entries)
#             text "subscription".pluralize(@subscriptions.total_entries)
#             text " matching this search "
#           else
#             text " Include all "
#             text number_with_delimiter(@subscriptions.total_entries)
#             text "subscription".pluralize(@subscriptions.total_entries)
#           end
#         end
#       end
#     end
#     ul(class: "mb-14") do
#       @subscriptions.each do |subscription|
#         present subscription do |subscription_presenter|
#           fields_for "subscriptions[]", subscription do |f|
#             li(class: "flex items-center relative border-b") do
#               div(class: "shrink-0 w-[32px] self-stretch flex") do
#                 check_box_tag "subscription_ids[]",
#                               subscription.id,
#                               false,
#                               id: "subscription_checkbox_#{subscription.id}",
#                               class: "peer",
#                               data: {
#                                 action: "toggle-checkboxes#toggleActions",
#                                 toggle_checkboxes_target: "checkbox"
#                               }
#                 label(
#                   class: "group w-full h-full flex items-center",
#                   for: "subscription_checkbox_#{subscription.id}"
#                 ) { text component "form/check_box" }
#               end
#               link_to edit_settings_subscription_path(subscription),
#                       class:
#                         "flex grow items-center overflow-hidden gap-3 py-3 !text-600 hover:no-underline" do
#                 span(class: "block") do
#                   text subscription_presenter.favicon(subscription.feed)
#                 end
#                 span(class: "truncate") do
#                   span(class: "block truncate") do
#                     text subscription.title
#                     span(class: "text-500 text-sm") do
#                       text timeago(subscription.last_published_entry)
#                       text ", "
#                       text number_with_delimiter(subscription.post_volume)
#                       text "/mo"
#                     end
#                   end
#                   span(class: "block truncate !text-500 text-sm") do
#                     text short_url(subscription.feed_url)
#                   end
#                 end
#                 span(class: "ml-auto flex items-center gap-4") do
#                   svg_tag "menu-icon-mute",
#                           class:
#                             class_names(
#                               [
#                                 "fill-600",
#                                 { "tw-hidden" => !subscription.muted? }
#                               ]
#                             ),
#                           title: "Muted",
#                           data: {
#                             toggle: "tooltip"
#                           }
#                   span(class: (subscription.muted? ? "tw-hidden" : "")) do
#                     render partial: "shared/sparkline",
#                            locals: {
#                              sparkline: subscription_presenter.sparkline
#                            }
#                   end
#                   svg_tag "icon-caret", class: "fill-300 -rotate-90"
#                 end
#               end
#             end
#           end
#         end
#       end
#     end
#   end
#   text will_paginate @subscriptions,
#                      previous_label: "Previous",
#                      next_label: "Next",
#                      inner_window: 1
# end