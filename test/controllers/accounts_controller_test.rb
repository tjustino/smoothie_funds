require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  # GET /users/1/accounts
  test "should get index" do
    get :index, user_id: @user
    assert_response :success
    assert_not_nil assigns(:accounts)
  end

  # GET /users/1/accounts/new
  test "should get new" do
    get :new, user_id: @user
    assert_response :success
  end

  # GET /users/1/accounts/1/edit
  test "should get edit" do
    @accounts.each do |account|
      get :edit, user_id: @user, id: account
      assert_response :success
    end
  end

  # POST /users/1/accounts
  test "should create account" do
    assert_difference('Account.count') do
      post :create, user_id: @user, account: {  name:             "My Account",
                                                initial_balance:  12.34,
                                                hidden:           false }
    end
    assert_redirected_to user_accounts_path
  end

  # PATCH/PUT /users/1/accounts/1
  test "should update account" do
    patch :update, user_id: @user, id: @accounts.first,
                            account: {  name:             "Account updated",
                                        initial_balance:  -15,
                                        hidden:           false }
    assert_redirected_to user_accounts_path
  end

  # DELETE /users/1/accounts/1
  test "should destroy account" do
    assert_no_difference('Account.count', -1) do
      delete :destroy, user_id: @user, id: @accounts.last
    end
    assert_redirected_to user_accounts_path

    @accounts.last.transactions.destroy_all
    @accounts.last.categories.destroy_all
    assert_difference('Account.count', -1) do
      delete :destroy, user_id: @user, id: @accounts.last
    end
    assert_redirected_to user_accounts_path
  end
end
