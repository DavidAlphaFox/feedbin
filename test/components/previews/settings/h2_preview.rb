# frozen_string_literal: true

class Settings::H2Preview < Lookbook::Preview
  def default
    render(Settings::H2Component.new) do
      "Header Two"
    end
  end
end
