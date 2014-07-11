require 'test_helper'

class TransactionsControllerTest < ActionController::TestCase
  # GET /users/1/accounts/1/transactions
  test "should get index" do
    @accounts.each do |account|
      get :index, user_id: @user, account_id: account
      assert_response :success
      assert_not_nil assigns(:transactions)
    end
  end

  # GET /users/1/accounts/1/transactions/new
  test "should get new" do
    @accounts.each do |account|
      get :new, user_id: @user, account_id: account
      assert_response :success
    end
  end

  # GET /users/1/accounts/1/transactions/1/edit
  test "should get edit" do
    @accounts.each do |account|
      account.transactions.each do |transaction|
        get :edit, user_id: @user, account_id: account, id: transaction
        assert_response :success
      end
    end
  end

  # POST /users/1/accounts/1/transactions
  test "should create transaction" do
    @accounts.each do |account|
      assert_difference('Transaction.count') do
        post :create, user_id:    @user, 
                      account_id: account,
                      transaction: {  category_id:  account.categories.sample,
                                      date:         DateTime.now,
                                      amount:       rand(-500.00..500.00),
                                      checked:      rand(0..1) == 1 ? true : false,
                                      comment:      SecureRandom.hex }

        assert_redirected_to user_account_transactions_path
      end
    end
  end

  # PATCH/PUT /users/1/accounts/1/transactions/1
  test "should update transaction" do
    @accounts.each do |account|
      account.transactions.each do |transaction|
        patch :update,  user_id:    @user,
                        account_id: account,
                        id:         transaction,
                        transaction: {  category_id:  account.categories.sample,
                                        date:         DateTime.now + rand(1..9).days,
                                        amount:       rand(-500.00..500.00),
                                        checked:      rand(0..1) == 1 ? true : false,
                                        comment:      SecureRandom.hex }

        assert_redirected_to user_account_transactions_path
      end
    end
  end

  # DELETE /users/1/accounts/1/transactions/1
  test "should destroy transaction" do
    @accounts.each do |account|
      account.transactions.each do |transaction|
        assert_difference('Transaction.count', -1) do
          delete :destroy, user_id: @user, account_id: account, id: transaction
        end

        assert_redirected_to user_account_transactions_path
      end
    end
  end

  # POST /users/1/accounts/1/transactions/1/easycheck
  test "should check easily transaction" do
    @accounts.each do |account|
      account.transactions.each do |transaction|
        request.env['HTTP_REFERER'] = "/previous_link_url"

        before = transaction.checked
        post :easycheck, user_id: @user, account_id: account, id: transaction
        after = transaction.reload.checked

        assert_not_equal before, after

        assert_redirected_to request.env['HTTP_REFERER']
      end
    end
  end
end
