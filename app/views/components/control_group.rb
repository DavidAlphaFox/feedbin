module Views
  module Components
    class ControlGroup < Phlex::HTML
      include PhlexSlots
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

      def with_item(...)
        @items << Item.new(...)
      end

      class Item < Phlex::HTML
        def initialize(options = {})
          @options = options
        end

        def template(&)
          div(**options, &)
        end

        private

        def options
          {
            class: [classes, @options.delete(:class)].reject(&:blank?).join(" "),
            data: data.merge(@options.delete(:data) || {})
          }.merge(@options)
        end

        def classes
          "border-b last:border-b-0"
        end

        def data
          {
            item: true
          }
        end

      end
    end
  end
end

# <div <%= tag.attributes(options) %>>
#   <%= header %>
#   <% if items? %>
#     <div class="border-y group-data-[capsule=true]:border group-data-[capsule=true]:rounded-lg" data-item-container>
#       <% items.each do |item| %>
#         <%= item %>
#       <% end %>
#     </div>
#   <% end %>
#   <% if description? %>
#     <p class="text-sm text-500 mt-2"><%= description %></p>
#   <% end %>
# </div>
