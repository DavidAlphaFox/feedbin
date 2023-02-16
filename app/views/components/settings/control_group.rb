module Views
  module Components
    module Settings
      class ControlGroup < Phlex::HTML
        include PhlexHelper
        include Phlex::DeferredRender

        slots :description

        def initialize(options = {})
          @options = options
          @items = []
        end

        def template
          div(**@options) do
            render(@header) if @header
            if @items
              div(class: "border-y group-data-[capsule=true]:border group-data-[capsule=true]:rounded-lg", data: {item_container: true}) do
                @items.each {render _1}
              end
            end
            div(class: "text-sm text-500 mt-2", &@description) if @description
          end
        end

        def header(...)
          @header = H2.new(...)
        end

        def item(...)
          @items << Item.new(...)
        end

        class Item < Phlex::HTML
          include PhlexHelper

          def initialize(attributes = {})
            @attributes = attributes
          end

          def template(&)
            div(**attributes, &)
          end

          private

          def attributes
            merge_attributes({class: "border-b last:border-b-0", data: {item: true}}, @attributes)
          end
        end
      end
    end
  end
end
