require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup { login_as :thomas }

  ################################################################################################################ GET /
  test "should get index" do
    get "/"

    assert_response :success
    assert_equal    session_user_id, users(:thomas).id
  end
end
