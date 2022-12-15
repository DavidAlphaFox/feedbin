class IconsControllerTestCase < ActionController::TestCase
  include Feedbin::Assertions
  setup do
    @request.headers["HTTP_HOST"] = "icons.#{@request.headers["HTTP_HOST"]}"
  end
end
