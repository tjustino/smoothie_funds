# frozen_string_literal: true

require "test_helper"

# Transactions Controller Test
class TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup { login_as :thomas }

  ############################################################################### GET /accounts/:account_id/transactions
  test "should get index" do
    get_index some_account_for(:thomas)

    assert_response :success
  end

  test "should not get index - hacker way" do
    get_index some_account_for(:emilie)

    assert_redirected_to dashboard_url
  end

  test "should not get index - unknow account" do
    get "/accounts/#{Account.maximum(:id) + 1}/transactions"

    assert_redirected_to dashboard_url
  end

  ########################################################################### GET /accounts/:account_id/transactions/new
  test "should get new" do
    get_new some_account_for(:thomas)

    assert_response :success
  end

  test "should not get new - hacker way" do
    get_new some_account_for(:emilie)

    assert_redirected_to dashboard_url
  end

  test "should not get new - unknow account" do
    get "/accounts/#{Account.maximum(:id) + 1}/transactions/new"

    assert_redirected_to dashboard_url
  end

  ########################################################################################### GET /transactions/:id/edit
  test "should get edit" do
    get_edit some_transaction_for(:thomas)

    assert_response :success
  end

  test "should not get edit - hacker way" do
    get_edit some_transaction_for(:emilie)

    assert_redirected_to dashboard_url
  end

  test "should not get edit - unknow transaction" do
    get "/transactions/#{Transaction.maximum(:id) + 1}/edit"

    assert_redirected_to dashboard_url
  end

  ############################################################################## POST /accounts/:account_id/transactions
  test "should create transaction" do
    assert_difference("Transaction.count") do
      account = some_account_for(:thomas)
      post_create account

      assert_redirected_to account_transactions_path(account)
      assert_equal         I18n.t("transactions.create.successfully_created"), flash[:notice]
    end
  end

  test "should not create transaction - hacker way" do
    assert_no_difference("Transaction.count") do
      post_create some_account_for(:emilie)

      assert_redirected_to dashboard_url
    end
  end

  ########################################################################################## PATCH/PUT /transactions/:id
  test "should update transaction" do
    transaction = some_transaction_for(:thomas)
    patch_update transaction

    assert_redirected_to account_transactions_path(transaction.account)
    assert_equal         I18n.t("transactions.update.successfully_updated"), flash[:notice]
    assert_not_equal     @previous_transaction_amount, transaction.reload.amount
  end

  test "should not update transaction - hacker way" do
    transaction = some_transaction_for(:emilie)
    patch_update transaction

    assert_redirected_to dashboard_url
    assert_equal         @previous_transaction_amount, transaction.reload.amount
  end

  ############################################################################################# DELETE /transactions/:id
  test "should destroy transaction" do
    assert_difference("Transaction.count", -1) do
      transaction_to_be_deleted = some_transaction_for(:thomas)
      delete_destroy transaction_to_be_deleted

      assert_redirected_to account_transactions_path(transaction_to_be_deleted.account)
      assert_equal         I18n.t("transactions.destroy.successfully_destroyed"), flash[:notice]
    end
  end

  test "should not destroy transaction - hacker way" do
    assert_no_difference "Transaction.count" do
      delete_destroy some_transaction_for(:emilie)

      assert_redirected_to dashboard_url
    end
  end

  ##################################################################################### POST /transactions/:id/easycheck
  test "should easycheck transaction" do
    transaction_to_be_checked = some_transaction_for(:thomas)
    post_easycheck transaction_to_be_checked

    assert_redirected_to account_transactions_path(transaction_to_be_checked.account)
    assert_equal         I18n.t("transactions.easycheck.successfully_checked"), flash[:notice]
    assert_not_equal     @previous_transaction_status, transaction_to_be_checked.reload.checked
  end

  test "should not easycheck transaction - hacker way" do
    wrong_transaction_to_be_checked = some_transaction_for(:emilie)
    post_easycheck wrong_transaction_to_be_checked

    assert_redirected_to dashboard_url
    assert_equal         @previous_transaction_status, wrong_transaction_to_be_checked.reload.checked
  end

  private ##############################################################################################################

    def get_index(account)
      get "/accounts/#{account.id}/transactions"
    end

    def get_new(account)
      get "/accounts/#{account.id}/transactions/new"
    end

    def get_edit(transaction)
      get "/transactions/#{transaction.id}/edit"
    end

    def post_create(account)
      post "/accounts/#{account.id}/transactions", params: { transaction: transaction_attributes(account) }
    end

    def patch_update(transaction)
      @previous_transaction_amount = transaction.amount
      patch "/transactions/#{transaction.id}", params: { transaction: transaction_attributes(transaction.account) }
    end

    def transaction_attributes(account)
      { category_id: some_category_for(account).id,
        date:        Time.zone.now + rand(1..9).days,
        amount:      rand(-500.00..500.00),
        checked:     true_or_false,
        comment:     SecureRandom.hex }
    end

    def delete_destroy(transaction)
      delete "/transactions/#{transaction.id}"
    end

    def post_easycheck(transaction)
      @previous_transaction_status = transaction.checked
      post "/transactions/#{transaction.id}/easycheck"
    end
end
