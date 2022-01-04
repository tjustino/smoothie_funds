# frozen_string_literal: true

require "test_helper"

# Transactions Controller Test
class TransactionsControllerTest < ActionController::TestCase
  ############################################################################### GET /accounts/:account_id/transactions
  test "should get index" do
    get_index       @some_account
    assert_response :success
  end

  test "should not get index - hacker way" do
    get_index            @some_wrong_account
    assert_redirected_to dashboard_url
  end

  test "should not get index - unknow account" do
    get_index            @unknow_account
    assert_redirected_to dashboard_url
  end

  ########################################################################### GET /accounts/:account_id/transactions/new
  test "should get new" do
    get_new         @some_account
    assert_response :success
  end

  test "should not get new - hacker way" do
    get_new              @some_wrong_account
    assert_redirected_to dashboard_url
  end

  test "should not get new - unknow account" do
    get_new              @unknow_account
    assert_redirected_to dashboard_url
  end

  ########################################################################################### GET /transactions/:id/edit
  # TODO: fix
  test "should get edit" do
    get_edit        @some_transaction
    assert_response :success
  end

  test "should not get edit - hacker way" do
    get_edit             @some_wrong_transaction
    assert_redirected_to dashboard_url
  end

  test "should not get edit - unknow transaction" do
    get_edit             @unknow_transaction
    assert_redirected_to dashboard_url
  end

  ############################################################################## POST /accounts/:account_id/transactions
  test "should create transaction" do
    assert_difference("Transaction.count") do
      post_create          @some_account
      assert_redirected_to account_transactions_path @some_account
      assert_equal         I18n.t("transactions.create.successfully_created"), flash[:notice]
    end
  end

  test "should not create transaction - hacker way" do
    assert_no_difference("Transaction.count") do
      post_create          @some_wrong_account
      assert_redirected_to dashboard_url
    end
  end

  ########################################################################################## PATCH/PUT /transactions/:id
  # TODO: fix
  test "should update transaction" do
    patch_update         @some_transaction
    assert_redirected_to account_transactions_path @some_account
    assert_equal         I18n.t("transactions.update.successfully_updated"), flash[:notice]
    assert_not_equal     @previous_transaction_amount, @some_transaction.reload.amount
  end

  test "should not update transaction - hacker way" do
    patch_update         @some_wrong_transaction
    assert_redirected_to dashboard_url
    assert_equal         @previous_transaction_amount,
                         @some_wrong_transaction.reload.amount
  end

  ############################################################################################# DELETE /transactions/:id
  # TODO: fix
  test "should destroy transaction" do
    assert_difference("Transaction.count", -1) do
      delete_destroy       @some_transaction
      assert_redirected_to account_transactions_path(@some_account)
      assert_equal         I18n.t("transactions.destroy.successfully_destroyed"), flash[:notice]
    end
  end

  test "should not destroy transaction - hacker way" do
    assert_no_difference "Transaction.count" do
      delete_destroy       @some_wrong_transaction
      assert_redirected_to dashboard_url
    end
  end

  ##################################################################################### POST /transactions/:id/easycheck
  # TODO: fix
  test "should easycheck transaction" do
    post_easycheck       @some_transaction
    assert_redirected_to account_transactions_path(@some_account)
    assert_equal         I18n.t("transactions.easycheck.successfully_checked"), flash[:notice]
    assert_not_equal     @previous_status, @some_transaction.reload.checked
  end

  test "should not easycheck transaction - hacker way" do
    post_easycheck       @some_wrong_transaction
    assert_redirected_to dashboard_url
    assert_equal         @previous_status, @some_wrong_transaction.reload.checked
  end

  private ##############################################################################################################

    def get_index(account)
      get :index, params: { account_id: account }
    end

    def get_new(account)
      get :new, params: { account_id: account }
    end

    def get_edit(transaction)
      get :edit, params: { id: transaction }
    end

    def post_create(account)
      post :create, params: {
        account_id:  account,
        transaction: transaction_attributes(account.categories.sample.id)
      }
    end

    def patch_update(transaction)
      @previous_transaction_amount = transaction.amount
      patch :update, params: {
        id:          transaction,
        transaction: transaction_attributes(transaction.account
                                                       .categories
                                                       .sample)
      }
    end

    def transaction_attributes(category)
      { category_id: category,
        date:        Time.zone.now + rand(1..9).days,
        amount:      rand(-500.00..500.00),
        checked:     true_or_false,
        comment:     SecureRandom.hex }
    end

    def delete_destroy(transaction)
      request.env["HTTP_REFERER"] = "/previous_link_url"
      delete :destroy, params: { id: transaction }
    end

    def post_easycheck(transaction)
      request.env["HTTP_REFERER"] = "/previous_link_url"
      @previous_status = transaction.checked
      post :easycheck, params: { id: transaction }
    end
end
