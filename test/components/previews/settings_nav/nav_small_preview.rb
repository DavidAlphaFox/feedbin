# frozen_string_literal: true

class SettingsNav::NavSmallPreview < Lookbook::Preview
  def default
    render(SettingsNav::NavSmall.new(url: "#")) do
      "Home"
    end
  end
end
