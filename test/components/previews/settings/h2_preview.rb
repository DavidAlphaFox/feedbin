# frozen_string_literal: true

class Settings::H2Preview < Lookbook::Preview
  def default
    render(Views::Components::Settings::H2.new) do
      "Header Two"
    end
  end
end
