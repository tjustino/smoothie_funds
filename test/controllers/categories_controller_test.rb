require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  # GET /users/1/accounts/1/categories
  test "should get index" do
    @accounts.each do |account|
      get :index, user_id: @user, account_id: account
      assert_response :success
      assert_not_nil assigns(:categories)
    end
  end

  # GET /users/1/accounts/1/categories/new
  test "should get new" do
    @accounts.each do |account|
      get :new, user_id: @user, account_id: account
      assert_response :success
    end
  end

  # GET /users/1/accounts/1/categories/1/edit
  test "should get edit" do
    @accounts.each do |account|
      account.categories.each do |category|
        get :edit, user_id: @user, account_id: account, id: category
        assert_response :success
      end
    end
  end

  # POST /users/1/accounts/1/categories
  test "should create category" do
    # @accounts.each do |account|
    #   assert_difference('Category.count') do
    #     post :create, user_id:    @user,
    #                   account_id: account,
    #                   category: { name: "New Category" }

    #     assert_redirected_to user_account_categories_path
    #   end
    # end
  end

  # PATCH/PUT /users/1/accounts/1/categories/1
  test "should update category" do
    @accounts.each do |account|
      account.categories.each do |category|
        patch :update,  user_id:    @user,
                        account_id: account,
                        id:         category,
                        category: { name: SecureRandom.hex }

        assert_redirected_to user_account_categories_path
      end
    end
  end

  # DELETE /users/1/accounts/1/categories/1
  test "should destroy category" do
    @accounts.each do |account|
      account.categories.each do |category|
        assert_no_difference('Category.count', -1) do
          delete :destroy, user_id: @user, account_id: account, id: category
        end

        assert_redirected_to user_account_categories_path
      end
    end

    # @accounts.each do |account|
    #   account.transactions.destroy_all
    #   account.categories.each do |category|
    #     assert_difference('Category.count', -1) do
    #       delete :destroy, user_id: @user, account_id: account, id: category
    #     end

    #     assert_redirected_to user_account_categories_path
    #   end
    # end
  end
end
