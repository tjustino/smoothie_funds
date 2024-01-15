# frozen_string_literal: true

require "test_helper"

# Users Controller Test
class UsersControllerTest < ActionDispatch::IntegrationTest
  setup { login_as :thomas }

  ####################################################################################################### GET /users/new
  test "should be redirected to dashboard url" do
    get "/users/new"

    assert_redirected_to dashboard_url
  end

  ################################################################################################## GET /users/:id/edit
  test "should get edit" do
    get_edit :thomas

    assert_response :success
  end

  test "should not get edit - hacker way" do
    get_edit :emilie

    assert_redirected_to dashboard_url
    assert_equal         session[:user_id], users(:thomas).id
  end

  test "should not get edit - unknow id" do
    get "/users/#{User.maximum(:id) + 1}/edit"

    assert_redirected_to dashboard_url
    assert_equal         session[:user_id], users(:thomas).id
  end

  ########################################################################################################## POST /users
  test "should create user" do
    # you can create an other user as a logged user, why not...
    assert_difference "User.count" do
      post "/users", params: { user: { email:                 "john.doe@email.com",
                                       password:              "unbreakablePassword",
                                       password_confirmation: "unbreakablePassword" } }

      assert_redirected_to login_url
      assert_equal         I18n.t("users.create.successfully_created"), flash[:notice]
    end
  end

  ################################################################################################# PATCH/PUT /users/:id
  test "should update user" do
    patch_update :thomas

    assert_redirected_to edit_user_url
    assert_equal         I18n.t("users.update.successfully_updated"), flash[:notice]
    assert_not_equal     @previous_user_name, users(:thomas).reload.name
  end

  test "should not update user - hacker way" do
    patch_update :emilie

    assert_redirected_to dashboard_url
    assert_equal         @previous_user_name, users(:emilie).reload.name
  end

  #################################################################################################### DELETE /users/:id
  test "should destroy user" do
    assert_difference("User.count", -1) do
      current_user = users(:thomas)
      delete_destroy current_user

      assert_redirected_to login_url
      assert_equal         I18n.t("users.destroy.successfully_destroyed"), flash[:notice]
      assert_empty         current_user.searches
      assert_empty         current_user.schedules
      assert_empty         current_user.transactions
      assert_empty         current_user.categories
      assert_empty         PendingUser.where(account_id: current_user.accounts)
      assert_empty         current_user.relations
      assert_empty         current_user.accounts
    end
  end

  test "should not destroy user - hacker way" do
    assert_no_difference(
      [ "User.count", "Search.count", "Schedule.count", "Transaction.count", "Category.count", "PendingUser.count",
        "Relation.count", "Account.count" ]
    ) do
      delete_destroy users(:emilie)

      assert_redirected_to dashboard_url
    end
  end

  private ##############################################################################################################

    def get_edit(user)
      get "/users/#{users(user).id}/edit"
    end

    def patch_update(user)
      @previous_user_name = users(user).name
      patch "/users/#{users(user).id}", params: { id:   users(user).id,
                                                  user: { email:                 users(user).email,
                                                          name:                  SecureRandom.hex,
                                                          password:              "p@ssw0rd!",
                                                          password_confirmation: "p@ssw0rd!" } }
    end

    def delete_destroy(user)
      delete "/users/#{user.id}"
    end
end
