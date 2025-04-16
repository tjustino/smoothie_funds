require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup { login_as :thomas }

  ################################################################################# GET /accounts/:account_id/categories
  test "should get index" do
    get_index :courant_thomas

    assert_response :success
  end

  test "should not get index - hacker way" do
    get_index :courant_emilie

    assert_redirected_to dashboard_url
  end

  test "should not get index - unknow account" do
    get "/accounts/#{Account.maximum(:id) + 1}/categories"

    assert_redirected_to dashboard_url
  end

  ############################################################################# GET /accounts/:account_id/categories/new
  test "should get new" do
    get_new :courant_thomas

    assert_response :success
  end

  test "should not get new - hacker way" do
    get_new :courant_emilie

    assert_redirected_to dashboard_url
  end

  test "should not get new - unknow account" do
    get "/accounts/#{Account.maximum(:id) + 1}/categories/new"

    assert_redirected_to dashboard_url
  end

  ############################################################################################# GET /categories/:id/edit
  test "should get edit" do
    get_edit :coiffeur_courant_thomas

    assert_response :success
  end

  test "should not get edit - hacker way" do
    get_edit :coiffeur_courant_emilie

    assert_redirected_to dashboard_url
  end

  test "should not get edit - unknow category" do
    get "/categories/#{Category.maximum(:id) + 1}/edit"

    assert_redirected_to dashboard_url
  end

  ################################################################################ POST /accounts/:account_id/categories
  test "should create category" do
    assert_difference("Category.count") do
      post_create :courant_thomas

      assert_redirected_to account_categories_path(accounts(:courant_thomas))
      assert_equal         I18n.t("categories.create.successfully_created"), flash[:notice]
    end
  end

  test "should not create category - hacker way" do
    assert_no_difference("Category.count") do
      post_create :courant_emilie

      assert_redirected_to dashboard_url
    end
  end

  test "should not create category - unknow account" do
    assert_no_difference("Category.count") do
      post "/accounts/#{Account.maximum(:id) + 1}/categories", params: { category: { name:   SecureRandom.hex,
                                                                                     hidden: true_or_false } }

      assert_redirected_to dashboard_url
    end
  end

  ############################################################################################ PATCH/PUT /categories/:id
  test "should update category" do
    patch_update :coiffeur_courant_thomas

    assert_redirected_to account_categories_path(accounts(:courant_thomas))
    assert_equal         I18n.t("categories.update.successfully_updated"), flash[:notice]
    assert_not_equal     @previous_category_name, categories(:coiffeur_courant_thomas).reload.name
  end

  test "should not update category - hacker way" do
    patch_update :coiffeur_courant_emilie

    assert_redirected_to dashboard_url
    assert_equal         @previous_category_name, categories(:coiffeur_courant_emilie).reload.name
  end

  ############################################################################################### DELETE /categories/:id
  test "should not destroy category with transactions" do
    assert_no_difference "Category.count" do
      delete_destroy :coiffeur_courant_thomas

      assert_no_turbo_stream action: "remove", target: categories(:coiffeur_courant_thomas)
      assert_equal           I18n.t("categories.destroy.cant_destroy"), flash[:warning]
    end
  end

  test "should destroy category without transactions" do
    categories(:coiffeur_courant_thomas).transactions.destroy_all

    assert_difference("Category.count", -1) do
      delete_destroy :coiffeur_courant_thomas

      assert_turbo_stream action: "remove", target: categories(:coiffeur_courant_thomas)
      assert_equal        I18n.t("categories.destroy.successfully_destroyed"), flash[:notice]
    end
  end

  test "should not destroy category - hacker way" do
    categories(:coiffeur_courant_emilie).transactions.destroy_all

    assert_no_difference "Category.count" do
      delete_destroy :coiffeur_courant_emilie

      assert_redirected_to dashboard_url
    end
  end

  #################################################################### POST /accounts/:account_id/categories/import_from
  test "should import categories from another account" do
    assert_difference("Category.count", accounts(:ldd_thomas).categories.count) do
      post_import_from(:courant_thomas, :ldd_thomas)
    end
  end

  # test "should not import categories from another account - hacker way" do
  # end

  # test "should not import categories from another account - unknow account" do
  # end

  private ##############################################################################################################

    def get_index(account)
      get "/accounts/#{accounts(account).id}/categories"
    end

    def get_new(account)
      get "/accounts/#{accounts(account).id}/categories/new"
    end

    def get_edit(category)
      get "/categories/#{categories(category).id}/edit"
    end

    def post_create(account)
      post "/accounts/#{accounts(account).id}/categories", params: { category: { name:   SecureRandom.hex,
                                                                                 hidden: true_or_false } }
    end

    def patch_update(category)
      @previous_category_name = categories(category).name

      patch "/categories/#{categories(category).id}", params: { category: { name:   SecureRandom.hex,
                                                                            hidden: true_or_false } }
    end

    def delete_destroy(category)
      delete "/categories/#{categories(category).id}", as: :turbo_stream
    end

    def post_import_from(first_account, second_account)
      post "/accounts/#{accounts(first_account).id}/categories/import_from",
           params: { categories: accounts(second_account).id }
    end
end
