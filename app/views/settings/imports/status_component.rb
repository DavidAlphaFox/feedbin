module Settings
  module Imports
    class StatusComponent < ApplicationComponent

      def initialize(failed_items:, import:)
        @failed_items = failed_items
        @import = import
      end

      def template
        render Settings::ControlGroupComponent.new class: "group mb-14", data: { capsule: "true" } do |group|
          group.item do
            div(class: "py-3 px-4") do
              div(class: "flex justify-between") do
                strong(class: "font-bold") { "Progress" }
                div(class: "text-500") do
                  plain helpers.number_with_delimiter(@import.import_items.where.not(status: :pending).count)
                  plain " of "
                  plain helpers.number_with_delimiter(@import.import_items.count)
                end
              end
              div(class: "flex mt-4 mb-2 bg-100 rounded-full w-full overflow-hidden") do
                div(class: "h-[12px] bg-green-600", style: "width: #{helpers.number_to_percentage(@import.percentage_complete)};", title: "#{helpers.number_with_delimiter(@import.import_items.complete.count)} imported", data: { toggle: "tooltip" }) {}
                div(class: "h-[12px] bg-red-600", style: "width: #{helpers.number_to_percentage(@import.percentage_failed)};", title: "#{helpers.number_with_delimiter(@failed_items.count)} missing", data: { toggle: "tooltip" }) {}
              end
              div(class: "flex justify-between gap-4") do
                div(class: "text-500 truncate") { plain @import.filename }
                span(class: "text-500 flex gap-2 items-center") do
                  if @import.percentage == 100
                    render SvgComponent.new "icon-check", class: "fill-green-600"
                  end
                  span do
                    helpers.number_to_percentage(@import.percentage.floor, precision: 0)
                  end
                end
              end
            end
          end
        end

        if @failed_items.present?
          div(class: "flex justify-between items-baseline") do
            render Settings::H2Component.new do
              plain " Missing Feeds "
            end
            div(class: "text-500") { helpers.number_with_delimiter(@failed_items.count) }
          end

          @failed_items.each { |import_item| render ImportItems::ImportItemComponent.new(import_item: import_item) }
        end
      end

    end
  end
end