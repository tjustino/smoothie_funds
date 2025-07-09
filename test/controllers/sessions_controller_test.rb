require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  ########################################################################################################### GET /login
  test "should redirect to dashboard url if user is already connected" do
    login_as :thomas
    get      "/login"

    assert_redirected_to dashboard_url
    assert_equal         session_user_id, users(:thomas).id
  end

  ########################################################################################################## POST /login
  test "should login with good credentials" do
    post "/login", params: { email: users(:thomas).email, password: "p@ssw0rd!" }

    assert_redirected_to dashboard_url
    assert_equal         session_user_id, users(:thomas).id
  end

  test "should redirect to the login URL with wrong credentials" do
    post "/login", params: { email: users(:thomas).email, password: "wrong_password" }

    assert_redirected_to login_url
    assert_equal         I18n.t("sessions.create.invalid_combination"), flash[:alert]
    assert_empty         Session.all
  end

  ####################################################################################################### DELETE /logout
  test "should logout" do
    login_as :thomas
    delete   "/logout"

    assert_redirected_to login_url
    assert_equal         I18n.t("sessions.destroy.logged_out"), flash[:notice]
    assert_empty         Session.all
  end
end
