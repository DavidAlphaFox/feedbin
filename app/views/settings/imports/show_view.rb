module Settings
  module Imports
    class ShowView < ApplicationView
      def initialize(import:, failed_items:)
        @import = import
        @failed_items = failed_items
      end

      def template
        render Settings::H1Component.new do
          "Import Status"
        end
        p class: "mb-8 -mt-6 text-500" do
          @import.created_at.to_formatted_s(:date)
        end
        div data: {content_src: helpers.settings_import_path(@import)} do
          render Settings::Imports::StatusComponent.new failed_items: @failed_items, import: @import
        end
        div data: {behavior: "import_items_target"} do
          @failed_items.each do |import_item|
            render ImportItems::ImportItemComponent.new(import_item: import_item)
          end
        end
      end
    end
  end
end
