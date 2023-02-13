module Views
  module Components
    class ControlGroup < Phlex::HTML
      def initialize
        @items = []
      end

      def template(&)
        yield(self)
        div do
          if @header
            render(@header)
          end
          if @items
            div(class: "border-y group-data-[capsule=true]:border group-data-[capsule=true]:rounded-lg", data: {item_container: true}) do
              @items.each do |item|
                render item
              end
            end
          end
          if @description
            div class: "text-sm text-500 mt-2", &@description
          end
        end
      end

      def header(**args, &block)
        @header = H2.new(**args, &block)
      end

      def description(&block)
        @description = block
      end

      def with_item(**args, &content)
        @items << Item.new(**args, &content)
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
