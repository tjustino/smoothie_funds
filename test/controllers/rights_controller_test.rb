require "test_helper"

class RightsControllerTest < ActionDispatch::IntegrationTest
  ########################################################################################################### GET /terms
  test "should get terms as logged user" do
    login_as :thomas
    get      "/terms"

    assert_response :success
    assert_equal    session_user_id, users(:thomas).id
  end

  test "should get terms as not logged user" do
    logout
    get "/terms"

    assert_response :success
    assert_empty    Session.all
  end

  ########################################################################################################## GET /cookie
  test "should get cookie as logged user" do
    login_as :thomas
    get      "/cookie"

    assert_response :success
    assert_equal    session_user_id, users(:thomas).id
  end

  test "should get cookie as not logged user" do
    logout
    get "/cookie"

    assert_response :success
    assert_empty    Session.all
  end

  ############################################################################################################ GET /gdpr
  test "should get gdpr as logged user" do
    login_as :thomas
    get      "/gdpr"

    assert_response :success
    assert_equal    session_user_id, users(:thomas).id
  end

  test "should get gdpr as not logged user" do
    logout
    get "/gdpr"

    assert_response :success
    assert_empty    Session.all
  end
end
