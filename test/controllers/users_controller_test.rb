# frozen_string_literal: true

require "test_helper"

# Users Controller Test
class UsersControllerTest < ActionController::TestCase
  ####################################################################################################### GET /users/new
  test "should be redirected to dashboard url" do
    get                   :new
    assert_redirected_to  dashboard_url
  end

  ################################################################################################## GET /users/:id/edit
  test "should get edit" do
    get_edit        @user
    assert_response :success
  end

  test "should not get edit - hacker way" do
    get_edit             @wrong_user
    assert_redirected_to dashboard_url
  end

  test "should not get edit - unknow id" do
    get_edit             User.maximum(:id) + 1
    assert_redirected_to dashboard_url
  end

  ########################################################################################################## POST /users
  test "should create user" do
    # you can create an other user as a logged user, why not...
    assert_difference "User.count" do
      post :create, params: {
        user: { email:                 "john.doe@email.com",
                password:              "unbreakablePassword",
                password_confirmation: "unbreakablePassword" }
      }
      assert_redirected_to login_url
      assert_equal         I18n.t("users.create.successfully_created"), flash[:notice]
    end
  end

  ################################################################################################# PATCH/PUT /users/:id
  test "should update user" do
    patch_update         @user
    assert_redirected_to edit_user_url
    assert_equal         I18n.t("users.update.successfully_updated"), flash[:notice]
    assert_not_equal     @previous_user_name, @user.reload.name
  end

  test "should not update user - hacker way" do
    patch_update         @wrong_user
    assert_redirected_to dashboard_url
    assert_equal         @previous_user_name, @wrong_user.reload.name
  end

  #################################################################################################### DELETE /users/:id
  test "should destroy user" do
    accounts = @user.accounts
    assert_difference("User.count", -1) do
      delete_destroy       @user
      assert_redirected_to login_url
      assert_equal         I18n.t("users.destroy.successfully_destroyed"), flash[:notice]
      assert_empty         @user.searches
      assert_empty         @user.schedules
      assert_empty         @user.transactions
      assert_empty         @user.categories
      assert_empty         PendingUser.where(account_id: accounts)
      assert_empty         @user.relations
      assert_empty         @user.accounts
    end
  end

  test "should not destroy user - hacker way" do
    assert_no_difference(
      ["User.count", "Search.count", "Schedule.count", "Transaction.count", "Category.count", "PendingUser.count",
       "Relation.count", "Account.count"]
    ) do
      delete_destroy       @wrong_user
      assert_redirected_to dashboard_url
    end
  end

  private ##############################################################################################################

    def get_edit(user)
      get :edit, params: { id: user }
    end

    def patch_update(user)
      @previous_user_name = user.name
      patch :update, params: {  id:   user,
                                user: { email:                 user.email,
                                        name:                  SecureRandom.hex,
                                        password:              "p@ssw0rd!",
                                        password_confirmation: "p@ssw0rd!" } }
    end

    def delete_destroy(user)
      delete :destroy, params: { id: user }
    end
end
