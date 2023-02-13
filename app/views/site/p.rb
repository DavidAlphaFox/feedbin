module Views
  class Site::P < Phlex::HTML
    def template
      render Components::ControlGroup.new do |group|
        group.header do
          "Header"
        end
        group.with_item do
          render(Components::ControlRow.new) do |row|
            row.icon do
              h1 { "Icon" }
            end
            row.title do
              "Title"
            end
            row.description do
              "description"
            end
            row.control do
              div(class: "h-4 w-4 bg-200")
            end
          end
        end
        group.with_item(data: {behavior: "action_x"}) do
          render(Components::ControlRow.new) do |row|
            row.icon do
              h1 { "Icon 2" }
            end
            row.title do
              "Title 2"
            end
            row.description do
              "description 2"
            end
            row.control do
              div(class: "h-4 w-4 bg-200")
            end
          end
        end
      end

      Components::ControlRow.new do |row|
        row.icon do
          h1 { "Icon" }
        end
        row.title do
          "Title"
        end
        row.description do
          "description"
        end
        row.control do
          div(class: "h-4 w-4 bg-200")
        end
      end
    end
  end
end


# module Views
#   class Site::P < Phlex::HTML
#     def template
#       render Components::ControlRow.new do |row|
#         row.icon do
#           h1 { "Icon" }
#         end
#
#         row.content do |content|
#           content.title do
#             "Title"
#           end
#           content.description do
#             "description"
#           end
#         end
#
#         row.control do
#           div(class: "h-4 w-4 bg-200")
#         end
#       end
#     end
#   end
# end
#
