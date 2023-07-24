module Settings
  module Imports
    class StatusComponent < ApplicationComponent

      def initialize(import:)
        @import = import
        @failed_items = @import
          .import_items
          .failed
          .includes(:discovered_feeds, :favicon)
          .sort_by { _1.title }

        @fixable_items = @import
          .import_items
          .fixable
          .includes(:discovered_feeds, :favicon)
          .sort_by { _1.title }
      end

      def template
        render Settings::ControlGroupComponent.new class: "group mb-8", data: { capsule: "true" } do |group|
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
                bar_segment(
                  title: "#{helpers.number_with_delimiter(@import.import_items.complete.count)} imported",
                  percent_complete: @import.percentage_complete,
                  color_class: "bg-green-600"
                )
                bar_segment(
                  title: "#{helpers.number_with_delimiter(@import.import_items.fixable.count)} fixable",
                  percent_complete: @import.percentage_fixable,
                  color_class: "bg-orange-600"
                )
                bar_segment(
                  title: "#{helpers.number_with_delimiter(@failed_items.count)} missing",
                  percent_complete: @import.percentage_failed,
                  color_class: "bg-red-600"
                )
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

        if @import.complete?
          tabs
        else
          p(class: "text-500") do
            "Import in progress. A detailed report will be available when the import completes."
          end
        end
      end

      def tabs
        if @failed_items.present?
          render TabsComponent.new do |tabs|
            tabs.tab(title: "Fixable") do
              div(class: "flex justify-between items-baseline mt-4") do
                render Settings::H2Component.new do
                  "Fixable Feeds "
                end
                div(class: "text-500") { helpers.number_with_delimiter(@fixable_items.count) }
              end

              @fixable_items.each do |import_item|
                render ImportItems::ImportItemComponent.new(import_item: import_item)
              end
            end
            tabs.tab(title: "Missing") do
              div(class: "flex justify-between items-baseline mt-4") do
                render Settings::H2Component.new do
                  "Missing Feeds "
                end
                div(class: "text-500") { helpers.number_with_delimiter(@failed_items.count) }
              end
              @failed_items.each do |import_item|
                render ImportItems::ImportItemComponent.new(import_item: import_item)
              end
            end
          end
        end
      end

      def bar_segment(title:, percent_complete:, color_class:)
        div(
          class: "h-[12px] #{color_class}",
          style: "width: #{helpers.number_to_percentage(percent_complete)};",
          title: "#{title}",
          data: { toggle: "tooltip" }
        )
      end
    end
  end
end