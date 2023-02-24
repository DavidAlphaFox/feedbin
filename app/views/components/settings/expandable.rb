module Views
  module Components
    module Settings
      class Expandable < Phlex::HTML
        include PhlexHelper
        include Phlex::DeferredRender

        slots :header, :description

        def initialize(attributes = {})
          @attributes = attributes
          @items = []
        end

        def template
          render Views::Components::Settings::ControlGroup.new(**attributes) do |group|
            group.header(&@header)
            group.item(&@description)
            group.item do
              div class: "grid [grid-template-rows:0fr] group-data-[expandable-open-value=true]:[grid-template-rows:1fr] transition-[grid-template-rows] duration-200 overflow-hidden" do
                ul class: "min-h-0 border-t transition transition-[visibility,opacity] opacity-100 group-data-[expandable-open-value=false]:opacity-0 group-data-[expandable-open-value=false]:invisible" do
                  @items.each {render _1}
                end
              end
            end
          end
        end

        def item(...)
          @items << Item.new(...)
        end

        private

        def attributes
          merge_attributes({class: "group [&_[data-item]]:border-0", data: { controller: "expandable", expandable_open_value: "false" }}, @attributes)
        end

        class Item < Phlex::HTML
          def template(&)
            li(class: "border-b last:border-b-0", &)
          end
        end
      end
    end
  end
end
