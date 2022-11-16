require "test_helper"

class ControlRow::ComponentTest < ActiveSupport::TestCase
  include ViewComponent::TestHelpers

  def test_renders
    component = build_component
    assert_selector "div", text: "title"
    assert_selector "div", text: "description"
    assert_selector "div", text: "control"
  end

  private

  def build_component(**options)
    render_inline(ControlRow::Component.new(**options)) do |c|
      c.title { "title" }
      c.description { "description" }
      c.control { "control" }
    end
  end
end
