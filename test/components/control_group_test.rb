require "test_helper"

class ControlGroup::ComponentTest < ActiveSupport::TestCase
  include ViewComponent::TestHelpers

  def test_renders
    component = build_component
    assert_selector "div", text: "header"
    assert_selector "li", text: "item"
  end

  private

  def build_component(**options)
    render_inline(ControlGroup::Component.new(**options)) do |c|
      c.header { "header" }
      c.item { "item" }
    end
  end
end
