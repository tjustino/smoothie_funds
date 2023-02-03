# frozen_string_literal: true

require "test_helper"

# Dashboard Controller Test
class DashboardControllerTest < ActionDispatch::IntegrationTest
  setup { login_as :thomas }

  ################################################################################################################ GET /
  test "should get index" do
    get "/"

    assert_response :success
    assert_equal    session[:user_id], users(:thomas).id
  end
end
