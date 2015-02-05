require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  # GET /users/new
  test "should get new" do
    get :new
    assert_response :success
  end

  # GET /users/1/edit
  test "should get edit" do
    get :edit, id: @user
    assert_response :success
    assert_select '.active > a:nth-child(1)'
  end

  test "should get edit only for current user" do
    get :edit, id: wrong_user
    assert_redirected_to dashboard_url
  end

  # POST /users
  test "should create user" do
    assert_difference('User.count') do
      post :create, user: { email: "foo@bar.com",
                            name: "John Doe", 
                            password: 'secret',
                            password_confirmation: 'secret' }
    end

    assert_redirected_to login_path
  end

  # PATCH/PUT /users/1
  test "should update user" do
    patch :update, id: @user, user: { email: @user.email,
                                      name: @user.name,
                                      password: 'secret',
                                      password_confirmation: 'secret' }
    assert_redirected_to edit_user_url
  end

  # DELETE /users/1
  test "should destroy user" do
    #TODO how to delete an account?
  end
end
