# frozen_string_literal: true

class Settings::H1Preview < Lookbook::Preview
  def default
    render Settings::H1Component.new do
      "Header One"
    end
  end
end
