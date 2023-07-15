module Settings
  module Subscriptions
    class IndexView < ApplicationView

      def initialize(user:, subscriptions:, params:)
        @user = user
        @subscriptions = subscriptions
        @params = params
      end

      def template
        form_tag helpers.settings_subscriptions_path, method: :get, remote: true, class: "feed-settings", data: {behavior: "spinner"} do
          render Settings::H1Component.new do
            "Subscriptions"
          end

          fix_feeds_notice

          div class: "flex flex-col md:flex-row justify-between mb-6 gap-2" do
            div class: "md:max-w-[250px]" do
              render Form::TextInputComponent.new do |input|
                input.input do
                  input(
                    type: "search",
                    class: "feed-search peer text-input",
                    placeholder: "Search Feeds",
                    data_behavior: "autosubmit",
                    name: "q",
                    value: @params[:q]
                  )
                end
                input.accessory_leading do
                  render SvgComponent.new "icon-search", class: "fill-400 pg-focus:fill-blue-600"
                end
              end
            end
            div class: "md:max-w-[250px]" do
              render Form::SelectInputComponent.new do |input|
                input.input do
                  select_tag(
                    :sort,
                    helpers.options_for_select([["Sort by Name", "name"], ["Sort by Last Updated", "updated"], ["Sort by Volume", "volume"]], @params[:sort]),
                    class: "peer",
                    data: {behavior: "autosubmit"}
                  )
                end
              end
            end
          end
        end

        render Shared::List.new(subscriptions: @subscriptions, params: @params)
      end

      def fix_feeds_notice
        if @user.setting_on?(:fix_feeds_flag) && @subscriptions.any? { _1.fix_suggestion_present? }
          div(class: "border rounded-lg flex gap-2 p-4 items-center mb-8") do
            div(class: "flex gap-2") do
              div class: "pt-1" do
                render SvgComponent.new "icon-fixable", class: "fill-orange-600"
              end
              div do
                p do
                  "Fixable Feeds"
                end
                p class: "text-sm text-500" do
                  "Feedbin is unable to update some feeds. However there are working alternatives available."
                end
              end
            end
            link_to "Review Feeds", helpers.fix_feeds_path, class: "whitespace-nowrap shrink-0"
          end
        end
      end
    end
  end
end

# render Settings::H1Component.new do
#   Subscriptions
# end
#
# form_tag settings_subscriptions_path, method: :get, remote: true, class: "feed-settings", data: {behavior: "spinner"} do
#
#   <div class="flex flex-col md:flex-row justify-between mb-6 gap-2">
#     <div class="md:max-w-[250px]">
#       render Form::TextInputComponent.new do |input|
#         input.input do
#           <input type="search" class="feed-search peer text-input" placeholder="Search Feeds" data-behavior="autosubmit" name="q" value="params[:q]" />
#         end
#         input.accessory_leading do
#           svg_tag "icon-search", class: "fill-400 pg-focus:fill-blue-600"
#         end
#       end
#     </div>
#
#     <div class="md:max-w-[250px]">
#       render Form::SelectInputComponent.new do |input|
#         input.input do
#           select_tag :sort, options_for_select([["Sort by Name", "name"], ["Sort by Last Updated", "updated"], ["Sort by Volume", "volume"]], params[:sort]), class: "peer", data: {behavior: "autosubmit"}
#         end
#       end
#     </div>
#   </div>
# end
#
# render partial: "subscriptions_list"
