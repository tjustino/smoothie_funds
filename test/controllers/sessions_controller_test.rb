# frozen_string_literal: true

require "test_helper"

# Sessions Controller Test
class SessionsControllerTest < ActionController::TestCase
  ########################################################################################################### GET /login
  test "should be redirected to dashboard url" do
    get                  :new
    assert_redirected_to dashboard_url
  end

  ########################################################################################################## POST /login
  test "should fail relogin" do
    post                 :create, params: { email: @user.email, password: "p@ssw0rd!" }
    assert_redirected_to dashboard_url
    assert_not           flash[:notice]
  end

  ####################################################################################################### DELETE /logout
  test "should logout" do
    delete               :destroy
    assert_redirected_to login_url
    assert_equal         I18n.t("sessions.destroy.logged_out"), flash[:notice]
  end
end
