module Views
  module Settings
    module Subscriptions
      class Index < Phlex::HTML
        include PhlexHelper

        def initialize(user:, subscriptions:, params:)
          @user = user
          @subscriptions = subscriptions
          @params = params
        end

        def template
          form_tag helpers.settings_subscriptions_path, method: :get, remote: true, class: "feed-settings", data: {behavior: "spinner"} do
            render Components::Settings::H1.new do
              "Settings"
            end
            div class: "flex flex-col md:flex-row justify-between mb-6 gap-2" do
              div class: "md:max-w-[250px]" do
                render Components::Form::TextInput.new do |input|
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
                    render Components::Svg.new "icon-search", class: "fill-400 pg-focus:fill-blue-600"
                  end
                end
              end
              div class: "md:max-w-[250px]" do
                render Components::Form::SelectInput.new do |input|
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
      end
    end
  end
end

# component "settings/h1" do
#   Subscriptions
# end
#
# form_tag settings_subscriptions_path, method: :get, remote: true, class: "feed-settings", data: {behavior: "spinner"} do
#
#   <div class="flex flex-col md:flex-row justify-between mb-6 gap-2">
#     <div class="md:max-w-[250px]">
#       component "form/text_input" do |input|
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
#       component "form/select_input" do |input|
#         input.input do
#           select_tag :sort, options_for_select([["Sort by Name", "name"], ["Sort by Last Updated", "updated"], ["Sort by Volume", "volume"]], params[:sort]), class: "peer", data: {behavior: "autosubmit"}
#         end
#       end
#     </div>
#   </div>
# end
#
# render partial: "subscriptions_list"
