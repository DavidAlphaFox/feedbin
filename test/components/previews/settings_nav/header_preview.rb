# frozen_string_literal: true

class SettingsNav::HeaderPreview < Lookbook::Preview
  def default
    render(Views::Components::SettingsNav::Header.new) do
      "Header"
    end
  end
end
