require 'test_helper'

class AccountsControllerTest < ActionController::TestCase
  ################################################################ GET /accounts
  test "should get index" do
    get             :index
    assert_response :success
    assert_not_nil  assigns(:accounts)
  end

  ############################################################ GET /accounts/new
  test "should get new" do
    get             :new
    assert_response :success
    assert_not_nil  assigns(:account)
  end

  ####################################################### GET /accounts/:id/edit
  test "should get edit" do
    get_edit        @some_account
    assert_response :success
    assert_not_nil  assigns(:account)
  end

  test "should not get edit - hacker way" do
    get_edit              @some_wrong_account
    assert_redirected_to  dashboard_url
  end

  test "should not get edit - unknow account" do
    get_edit              @unknow_account
    assert_redirected_to  dashboard_url
  end

  ############################################################### POST /accounts
  test "should create account" do
    assert_difference 'Account.count' do
      post  :create,
            account: {  name:             SecureRandom.hex,
                        initial_balance:  rand(-100..100),
                        hidden:           rand(0..1) == 1 ? true : false }
      assert_redirected_to  accounts_url
      assert_equal          I18n.translate('accounts.create.successfully_created'),
                            flash[:notice]
    end
  end

  ###################################################### PATCH/PUT /accounts/:id
  test "should update account" do
    patch_update          @some_account
    assert_not_nil        assigns(:account)
    assert_redirected_to  accounts_path
    assert_equal          I18n.translate('accounts.update.successfully_updated'),
                          flash[:notice]
    assert_not_equal      @previous_account_name, @some_account.reload.name
  end

  test "should not update account - hacker way" do
    patch_update          @some_wrong_account
    assert_nil            assigns(:account)
    assert_redirected_to  dashboard_url
    assert_equal          @previous_account_name, @some_wrong_account.reload.name
  end

  ######################################################### DELETE /accounts/:id
  test "should not destroy account with transactions, schedules or categories" do
    assert_no_difference 'Account.count' do
      delete_destroy        @some_account
      assert_not_nil        assigns(:account)
      assert_redirected_to  accounts_path
      assert_equal          I18n.translate('accounts.destroy.cant_destroy'),
                            flash[:warning]
    end
  end

  test "should destroy account without transactions, schedules or categories" do
    @some_account.transactions.destroy_all
    @some_account.schedules.destroy_all
    @some_account.categories.destroy_all

    assert_difference('Account.count', -1) do
      delete_destroy        @some_account
      assert_not_nil        assigns(:account)
      assert_redirected_to  accounts_path
      assert_equal          I18n.translate('accounts.destroy.successfully_destroyed'),
                            flash[:notice]
    end
  end

  test "should not destroy account - hacker way" do
    @some_wrong_account.transactions.destroy_all
    @some_wrong_account.schedules.destroy_all
    @some_wrong_account.categories.destroy_all

    assert_no_difference 'Account.count' do
      delete_destroy        @some_wrong_account
      assert_nil            assigns(:account)
      assert_redirected_to  dashboard_url
    end
  end

  ################################################## DELETE /accounts/:id/unlink
  test "should unlink shared account" do
    delete_unlink         accounts(:compte_commun)
    assert_equal          1, accounts(:compte_commun).users.count
    assert_redirected_to  accounts_path
    assert_equal          I18n.translate('accounts.unlink.successfully_unlinked'),
                          flash[:notice]
  end

  test "should not unlink personal account" do
    delete_unlink         accounts(:courant_thomas)
    assert_equal          1, accounts(:courant_thomas).users.count
    assert_redirected_to  accounts_path
    assert_equal          I18n.translate('accounts.unlink.cant_unlink'),
                          flash[:warning]
  end

  test "should not unlink shared account - hacker way" do
    delete_unlink         accounts(:compte_commun_jackpot)
    assert_equal          2, accounts(:compte_commun_jackpot).users.count
    assert_redirected_to  dashboard_url
  end

  test "should not unlink shared account - unknow account" do
    delete_unlink         @unknow_account
    assert_redirected_to  dashboard_url
  end

private ########################################################################

  def get_edit(account)
    get :edit, id: account
  end

  def patch_update(account)
    @previous_account_name = account.name

    patch :update,
          id: account,
          account: {  name:             SecureRandom.hex,
                      initial_balance:  rand(-100..100),
                      hidden:           rand(0..1) == 1 ? true : false }
  end

  def delete_destroy(account)
    delete :destroy, id: account
  end

  def delete_unlink(account)
    delete :unlink, id: account
  end
end
