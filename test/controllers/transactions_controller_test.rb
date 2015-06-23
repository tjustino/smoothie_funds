require 'test_helper'

class TransactionsControllerTest < ActionController::TestCase
  ####################################### GET /accounts/:account_id/transactions
  test "should get index" do
    get_index       @some_account
    assert_response :success
    assert_not_nil  assigns(:transactions)
  end

  test "should not get index - hacker way" do
    get_index             @some_wrong_account
    assert_redirected_to  dashboard_url
  end

  test "should not get index - unknow account" do
    get_index             @unknow_account
    assert_redirected_to  dashboard_url
  end

  ################################### GET /accounts/:account_id/transactions/new
  test "should get new" do
    get_new         @some_account
    assert_response :success
    assert_not_nil  assigns(:transaction)
  end

  test "should not get new - hacker way" do
    get_new               @some_wrong_account
    assert_redirected_to  dashboard_url
  end

  test "should not get new - unknow account" do
    get_new               @unknow_account
    assert_redirected_to  dashboard_url
  end

  ################################################### GET /transactions/:id/edit
  test "should get edit" do
    get_edit        @some_transaction
    assert_response :success
    assert_not_nil  assigns(:transaction)
  end

  test "should not get edit - hacker way" do
    get_edit              @some_wrong_transaction
    assert_redirected_to  dashboard_url
  end

  test "should not get edit - unknow transaction" do
    get_edit              @unknow_transaction
    assert_redirected_to  dashboard_url
  end

  ###################################### POST /accounts/:account_id/transactions
  test "should create transaction" do
    assert_difference('Transaction.count') do
      post_create           @some_account
      assert_not_nil        assigns(:transaction)
      assert_redirected_to  account_transactions_path @some_account
      assert_equal          I18n.translate('transactions.create.successfully_created'),
                            flash[:notice]
    end
  end

  test "should not create transaction - hacker way" do
    assert_no_difference('Transaction.count') do
      post_create           @some_wrong_account
      assert_redirected_to  dashboard_url
    end
  end

  ################################################## PATCH/PUT /transactions/:id
  test "should update transaction" do
    patch_update          @some_transaction
    assert_not_nil        assigns(:transaction)
    assert_redirected_to  account_transactions_path @some_account
    assert_equal          I18n.translate('transactions.update.successfully_updated'),
                          flash[:notice]
    assert_not_equal      @previous_transaction_amount, @some_transaction.reload.amount
  end

  test "should not update transaction - hacker way" do
    patch_update          @some_wrong_transaction
    assert_nil            assigns(:transaction)
    assert_redirected_to  dashboard_url
    assert_equal          @previous_transaction_amount, @some_wrong_transaction.reload.amount
  end

  ##################################################### DELETE /transactions/:id
  test "should destroy transaction" do
    assert_difference('Transaction.count', -1) do
      delete_destroy        @some_transaction
      assert_not_nil        assigns(:transaction)
      assert_redirected_to  request.env['HTTP_REFERER']
      assert_equal          I18n.translate('transactions.destroy.successfully_destroyed'),
                            flash[:notice]
    end
  end

  test "should not destroy transaction - hacker way" do
    assert_no_difference 'Transaction.count' do
      delete_destroy        @some_wrong_transaction
      assert_nil            assigns(:transaction)
      assert_redirected_to  dashboard_url
    end
  end

  ############################################# POST /transactions/:id/easycheck
  test "should easycheck transaction" do
    post_easycheck        @some_transaction
    assert_not_nil        assigns(:transaction)
    assert_redirected_to  request.env['HTTP_REFERER']
    assert_equal          I18n.translate('transactions.easycheck.successfully_checked'),
                          flash[:notice]
    assert_not_equal      @previous_status, @some_transaction.reload.checked
  end

  test "should not easycheck transaction - hacker way" do
    post_easycheck        @some_wrong_transaction
    assert_nil            assigns(:transaction)
    assert_redirected_to  dashboard_url
    assert_equal          @previous_status, @some_wrong_transaction.reload.checked
  end


  private ######################################################################

    def get_index(account)
      get :index, account_id: account
    end

    def get_new(account)
      get :new, account_id: account
    end

    def get_edit(transaction)
      get :edit, id: transaction
    end

    def post_create(account)
      post :create, account_id:   account,
                    transaction:  { category_id:  account.categories.sample.id,
                                    date:         DateTime.now + rand(1..9).days,
                                    amount:       rand(-500.00..500.00),
                                    checked:      rand(0..1) == 1 ? true : false,
                                    comment:      SecureRandom.hex }
    end

    def patch_update(transaction)
      @previous_transaction_amount = transaction.amount

      patch :update,  id:           transaction,
                      transaction:  { category_id:  transaction.account.categories.sample,
                                      date:         DateTime.now + rand(1..9).days,
                                      amount:       rand(-500.00..500.00),
                                      checked:      rand(0..1) == 1 ? true : false,
                                      comment:      SecureRandom.hex }
    end

    def delete_destroy(transaction)
      request.env['HTTP_REFERER'] = "/previous_link_url"
      delete :destroy, id: transaction
    end

    def post_easycheck(transaction)
      request.env['HTTP_REFERER'] = "/previous_link_url"
      @previous_status = transaction.checked

      post :easycheck, id: transaction
    end
end
