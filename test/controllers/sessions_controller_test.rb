require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  # GET /sessions/new
  test "should get new" do
    get :new
    assert_response :success
  end

  # POST /sessions
  test "should login" do
    thomas = users(:thomas)
    post :create, email: thomas.email, password: 'secret'
    assert_redirected_to dashboard_url
    assert_equal thomas.id, session[:user_id]
  end

  test "should fail login" do
    thomas = users(:thomas)
    post :create, email: thomas.email, password: 'wrong'
    assert_redirected_to login_url
    assert_select 'ul.nav:nth-child(2) > li:nth-child(1) > a:nth-child(1)',
                  false,
                  users(:thomas).name
  end

  # DELETE /sessions/1
  test "should logout" do
    delete :destroy
    assert_redirected_to login_url
  end
end
