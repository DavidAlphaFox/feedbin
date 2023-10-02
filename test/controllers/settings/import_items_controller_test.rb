require "test_helper"

class Settings::ImportItemsControllerTest < ActionController::TestCase
  setup do
    @user = users(:ben)
  end

  test "fix import" do
    login_as @user
    get :index
    assert_response :success
  end
end
