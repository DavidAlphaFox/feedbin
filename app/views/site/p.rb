module Views
  class Site::P < Phlex::HTML
    include PhlexHelper

    def initialize(user:)
      @user = user
    end

    def template
      form_for @user, remote: true, url: helpers.settings_update_user_path(@user) do |f|
        render Components::Settings::ControlGroup.new(class: "mb-14") do |group|
          group.header do
            "Unread Sort"
          end
          group.item do
            f.radio_button(:entry_sort, "DESC", checked: @user.entry_sort.nil? || @user.entry_sort === "DESC", class: "peer", data: {behavior: "auto_submit"})
            f.label :entry_sort_desc, class: "group" do
              render Components::Settings::ControlRow.new do |row|
                row.title { "Newest First" }
                row.control { render Components::Form::Radio.new }
              end
            end
          end
          group.item do
            f.radio_button(:entry_sort, "ASC", class: "peer", data: {behavior: "auto_submit"})
            f.label :entry_sort_asc, class: "group" do
              render Components::Settings::ControlRow.new do |row|
                row.title { "Oldest First" }
                row.control { render Components::Form::Radio.new }
              end
            end
          end
        end

        render Components::Settings::ControlGroup.new(class: "mb-14") do |group|
          group.header do
            "Collections"
          end
          group.item do
            f.check_box :hide_updated, {checked: @user.hide_updated.nil? || !@user.setting_on?(:hide_updated), class: "peer", data: {behavior: "auto_submit"}}, "0", "1"
            f.label :hide_updated, class: "group" do
              render Components::Settings::ControlRow.new do |row|
                row.title { "Updated" }
                row.control { render Components::Form::Switch.new }
              end
            end
          end
          group.item do
            f.check_box :hide_recently_read, {checked: @user.hide_recently_read.nil? || !@user.setting_on?(:hide_recently_read), class: "peer", data: {behavior: "auto_submit"}}, "0", "1"
            f.label :hide_recently_read, class: "group" do
              render Components::Settings::ControlRow.new do |row|
                row.title { "Recently Read" }
                row.control { render Components::Form::Switch.new }
              end
            end
          end
          if @user.recently_played_entries.exists?
            group.item do
              f.check_box :hide_recently_played, {checked: @user.hide_recently_played.nil? || !@user.setting_on?(:hide_recently_played), class: "peer", data: {behavior: "auto_submit"}}, "0", "1"
              f.label :hide_recently_played, class: "group" do
                render Components::Settings::ControlRow.new do |row|
                  row.title { "Recently Played" }
                  row.control { render Components::Form::Switch.new }
                end
              end
            end
          end
          if @user.queued_entries.exists?
            group.item do
              f.check_box :hide_airshow, {checked: @user.hide_airshow.nil? || !@user.setting_on?(:hide_airshow), class: "peer", data: {behavior: "auto_submit"}}, "0", "1"
              f.label :hide_airshow, class: "group" do
                render Components::Settings::ControlRow.new do |row|
                  row.title { "Airshow" }
                  row.control { render Components::Form::Switch.new }
                end
              end
            end
          end
        end

        render Components::Settings::ControlGroup.new(class: "mb-14") do |group|
          group.header do
            "Advanced"
          end
          group.item do
            f.check_box :view_links_in_app, {checked: @user.setting_on?(:view_links_in_app), class: "peer", data: {behavior: "auto_submit"}}, "1", "0"
            f.label :view_links_in_app, class: "group" do
              render Components::Settings::ControlRow.new do |row|
                row.title {"Always view links in Feedbin" }
                row.description do
                  text "Load article links in Feedbin‘s "
                  a(href: "/blog/2017/07/25/view-links-in-feedbin/") { "link viewer" }
                  text " by default."
                end
                row.control { render Components::Form::Switch.new }
              end
            end
          end
          group.item do
            f.check_box :disable_image_proxy, {checked: @user.disable_image_proxy.nil? || !@user.setting_on?(:disable_image_proxy), class: "peer", data: {behavior: "auto_submit"}}, "0", "1"
            f.label :disable_image_proxy, class: "group" do
              render Components::Settings::ControlRow.new do |row|
                row.title { "Image proxy" }
                row.description do
                  text "A TLS enabled image proxy is used to prevent "
                  a(href: "https://developer.mozilla.org/en-US/docs/Security/MixedContent") { "mixed content" }
                  text " warnings. You can turn it off if you experience image loading issues."
                end
                row.control { render Components::Form::Switch.new }
              end
            end
          end
        end

      end
    end
  end
end
