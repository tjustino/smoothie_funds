require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  ############################################################### GET /users/new
  test "should be redirected to dashboard url" do
    get                   :new
    assert_redirected_to  dashboard_url
  end

  ########################################################## GET /users/:id/edit
  test "should get edit" do
    get_edit        @user
    assert_response :success
    #assert_not_nil  assigns(:user)
  end

  test "should not get edit - hacker way" do
    get_edit              @wrong_user
    assert_redirected_to  dashboard_url
  end

  test "should not get edit - unknow id" do
    get_edit              User.maximum(:id) + 1
    assert_redirected_to  dashboard_url
  end

  ################################################################## POST /users
  test "should create user" do
    # you can create an other user as a logged user, why not...
    assert_difference 'User.count' do
      post :create, params: { user: { email:                  "john.doe@email.com",
                                      password:               "unbreakablePassword",
                                      password_confirmation:  "unbreakablePassword" } }
      assert_redirected_to  login_url
      assert_equal          I18n.translate('users.create.successfully_created'),
                            flash[:notice]
    end
  end

  ######################################################### PATCH/PUT /users/:id
  test "should update user" do
    patch_update          @user
    assert_redirected_to  edit_user_url
    assert_equal          I18n.translate('users.update.successfully_updated'),
                          flash[:notice]
    assert_not_equal      @previous_user_name, @user.reload.name
  end

  test "should not update user - hacker way" do
    patch_update          @wrong_user
    assert_redirected_to  dashboard_url
    assert_equal          @previous_user_name, @wrong_user.reload.name
  end

  ############################################################ DELETE /users/:id
  # TODO how to delete an account?
  # test "should destroy user" do
  # end


  private ######################################################################

    def get_edit(user)
      get :edit, params: { id: user }
    end

    def patch_update(user)
      @previous_user_name = user.name

      patch :update, params: {  id: user, 
                                user: { email:                  user.email,
                                        name:                   SecureRandom.hex,
                                        password:               "secret",
                                        password_confirmation:  "secret" } }
    end
end
