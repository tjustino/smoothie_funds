require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase
  ######################################### GET /accounts/:account_id/categories
  test "should get index" do
    get_index       @some_account
    assert_response :success
    assert_not_nil  assigns(:categories)
  end

  test "should not get index - hacker way" do
    get_index             @some_wrong_account
    assert_redirected_to  dashboard_url
  end

  test "should not get index - unknow account" do
    get_index             @unknow_account
    assert_redirected_to  dashboard_url
  end

  ##################################### GET /accounts/:account_id/categories/new
  test "should get new" do
    get_new         @some_account
    assert_response :success
    assert_not_nil  assigns(:category)
  end

  test "should not get new - hacker way" do
    get_new               @some_wrong_account
    assert_redirected_to  dashboard_url
  end

  test "should not get new - unknow account" do
    get_new               @unknow_account
    assert_redirected_to  dashboard_url
  end

  ##################################################### GET /categories/:id/edit
  test "should get edit" do
    get_edit        @some_category
    assert_response :success
    assert_not_nil  assigns(:category)
  end

  test "should not get edit - hacker way" do
    get_edit              @some_wrong_category
    assert_redirected_to  dashboard_url
  end

  test "should not get edit - unknow category" do
    get_edit              @unknow_category
    assert_redirected_to  dashboard_url
  end

  ######################################## POST /accounts/:account_id/categories
  test "should create category" do
    assert_difference('Category.count') do
      post_create           @some_account
      assert_not_nil        assigns(:category)
      assert_redirected_to  account_categories_path @some_account
      assert_equal          I18n.translate('categories.create.successfully_created'),
                            flash[:notice]
    end
  end

  test "should not create category - hacker way" do
    assert_no_difference('Category.count') do
      post_create           @some_wrong_account
      assert_redirected_to  dashboard_url
    end
  end

  test "should not create category - unknow account" do
    assert_no_difference('Category.count') do
      post_create           @unknow_account
      assert_redirected_to  dashboard_url
    end
  end

  #################################################### PATCH/PUT /categories/:id
  test "should update category" do
    patch_update          @some_category
    assert_not_nil        assigns(:category)
    assert_redirected_to  account_categories_path @some_account
    assert_equal          I18n.translate('categories.update.successfully_updated'),
                          flash[:notice]
    assert_not_equal      @previous_category_name, @some_category.reload.name
  end

  test "should not update category - hacker way" do
    patch_update          @some_wrong_category
    assert_nil            assigns(:category)
    assert_redirected_to  dashboard_url
    assert_equal          @previous_category_name, @some_wrong_category.reload.name
  end

  ####################################################### DELETE /categories/:id
  test "should not destroy category with transactions" do
    assert_no_difference 'Category.count' do
      delete_destroy        @some_category
      assert_not_nil        assigns(:category)
      assert_redirected_to  account_categories_path @some_account
      assert_equal          I18n.translate('categories.destroy.cant_destroy'),
                            flash[:warning]
    end
  end

  test "should destroy category without transactions" do
    @some_category.transactions.destroy_all

    assert_difference('Category.count', -1) do
      delete_destroy        @some_category
      assert_not_nil        assigns(:category)
      assert_redirected_to  account_categories_path @some_account
      assert_equal          I18n.translate('categories.destroy.successfully_destroyed'),
                            flash[:notice]
    end
  end

  test "should not destroy category - hacker way" do
    @some_wrong_category.transactions.destroy_all

    assert_no_difference 'Category.count' do
      delete_destroy        @some_wrong_category
      assert_nil            assigns(:category)
      assert_redirected_to  dashboard_url
    end
  end

  #TODO how to test? refactoring route/controller?
  # POST /accounts/:account_id/categories/import_from
  # test "should import categories from another account" do
  # end

  # test "should not import categories from another account - hacker way" do
  # end

  # test "should not import categories from another account - unknow account" do
  # end


  private ######################################################################

    def get_index(account)
      get :index, account_id: account
    end

    def get_new(account)
      get :new, account_id: account
    end

    def get_edit(category)
      get :edit, id: category
    end

    def post_create(account)
      post :create, account_id: account,
                    category:   { name: SecureRandom.hex }
    end

    def patch_update(category)
      @previous_category_name = category.name

      patch :update,  id:       category,
                      category: { name: SecureRandom.hex }
    end

    def delete_destroy(category)
      delete :destroy, id: category
    end
end
