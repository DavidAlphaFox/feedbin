# frozen_string_literal: true

class SettingsNav::HeaderPreview < Lookbook::Preview
  def default
    render(SettingsNav::HeaderComponent.new) do
      "Header"
    end
  end
end
