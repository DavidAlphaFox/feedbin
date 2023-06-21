# frozen_string_literal: true

class Settings::H1Preview < Lookbook::Preview
  def default
    render(Settings::H1.new) do
      "Header One"
    end
  end
end
