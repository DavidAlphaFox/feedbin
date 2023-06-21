# frozen_string_literal: true

class SettingsNav::NavPreview < Lookbook::Preview
  # @param selected toggle
  def default(selected: false)
    render(SettingsNav::Nav.new(title: "Title", subtitle: "Subtitle", url: "#", icon: "menu-icon-settings", selected: selected))
  end
end
