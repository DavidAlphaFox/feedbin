# <%= f.radio_button(:entry_sort, "DESC", checked: @user.entry_sort.nil? || @user.entry_sort === 'DESC', class: "peer", data: {behavior: "auto_submit"}) %>
# <%= f.label :entry_sort_desc, class: "group" do %>
#   <%= component "settings/control_row_radio" do |row| %>
#     <% row.title { "Newest First" } %>
#   <% end %>
# <% end %>

module Views
  class Site::P < Phlex::HTML
    include Phlex::Rails::Helpers::FormFor
    def template
      form_for User.new, remote: true, url: helpers.settings_update_user_path(1) do |f|
        render Components::ControlGroup.new do |group|
          group.header do
            "Unread Sort"
          end
          group.with_item do
            sdfasdf
          end
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
