# frozen_string_literal: true

require "test_helper"

# Accounts Controller Test
class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup { login_as :thomas }

  ######################################################################################################## GET /accounts
  test "should get index" do
    get "/accounts"

    assert_response :success
  end

  #################################################################################################### GET /accounts/new
  test "should get new" do
    get "/accounts/new"

    assert_response :success
  end

  ############################################################################################### GET /accounts/:id/edit
  test "should get edit" do
    get_edit :courant_thomas

    assert_response :success
  end

  test "should not get edit - hacker way" do
    get_edit :courant_emilie

    assert_redirected_to dashboard_url
  end

  test "should not get edit - unknow account" do
    get "/accounts/#{Account.maximum(:id) + 1}/edit"

    assert_redirected_to dashboard_url
  end

  ####################################################################################################### POST /accounts
  test "should create account" do
    assert_difference "Account.count" do
      post "/accounts", params: { account: { name:            SecureRandom.hex,
                                             initial_balance: rand(-100..100),
                                             hidden:          true_or_false } }

      assert_redirected_to accounts_url
      assert_equal         I18n.t("accounts.create.successfully_created"), flash[:notice]
    end
  end

  ############################################################################################## PATCH/PUT /accounts/:id
  test "should update account" do
    patch_update :courant_thomas

    assert_redirected_to accounts_path
    assert_equal         I18n.t("accounts.update.successfully_updated"), flash[:notice]
    assert_not_equal     @previous_account_name, accounts(:courant_thomas).reload.name
  end

  test "should not update account - hacker way" do
    patch_update :courant_emilie

    assert_redirected_to dashboard_url
    assert_equal         @previous_account_name, accounts(:courant_emilie).reload.name
  end

  ################################################################################################# DELETE /accounts/:id
  test "should not destroy account with transactions schedules or categories" do
    assert_no_difference "Account.count" do
      delete_destroy :courant_thomas

      assert_redirected_to accounts_path
      assert_equal         I18n.t("accounts.destroy.cant_destroy"), flash[:warning]
    end
  end

  test "should destroy account without transactions, schedules or categories" do
    accounts(:courant_thomas).transactions.destroy_all
    accounts(:courant_thomas).schedules.destroy_all
    accounts(:courant_thomas).categories.destroy_all

    assert_difference("Account.count", -1) do
      delete_destroy :courant_thomas

      assert_redirected_to accounts_path
      assert_equal         I18n.t("accounts.destroy.successfully_destroyed"), flash[:notice]
    end
  end

  test "should not destroy account - hacker way" do
    accounts(:courant_emilie).transactions.destroy_all
    accounts(:courant_emilie).schedules.destroy_all
    accounts(:courant_emilie).categories.destroy_all

    assert_no_difference "Account.count" do
      delete_destroy :courant_emilie

      assert_redirected_to dashboard_url
    end
  end

  ########################################################################################## DELETE /accounts/:id/unlink
  test "should unlink shared account" do
    assert_equal  2, accounts(:compte_commun).users.count
    delete_unlink :compte_commun

    assert_equal         1, accounts(:compte_commun).reload.users.count
    assert_redirected_to accounts_path
    assert_equal         I18n.t("accounts.unlink.successfully_unlinked"), flash[:notice]
  end

  test "should not unlink personal account" do
    assert_equal  1, accounts(:courant_thomas).users.count
    delete_unlink :courant_thomas

    assert_equal         1, accounts(:courant_thomas).reload.users.count
    assert_redirected_to accounts_path
    assert_equal         I18n.t("accounts.unlink.cant_unlink"), flash[:warning]
  end

  test "should not unlink shared account - hacker way" do
    delete_unlink :compte_commun_benoit_vanessa

    assert_equal         2, accounts(:compte_commun_benoit_vanessa).users.count
    assert_redirected_to dashboard_url
  end

  test "should not unlink shared account - unknow account" do
    delete "/accounts/#{Account.maximum(:id) + 1}/unlink"

    assert_redirected_to dashboard_url
  end

  ########################################################################################## DELETE /accounts/:id/unpend
  test "should unpend shared account" do
    assert_not_nil accounts(:thomas_account_waiting_benoit).pending_user
    delete_unpend  :thomas_account_waiting_benoit

    assert_nil           accounts(:thomas_account_waiting_benoit).reload.pending_user
    assert_redirected_to accounts_path
    assert_equal         I18n.t(
      "accounts.unpend.successfully_unpend", account: accounts(:thomas_account_waiting_benoit).name
    ), flash[:notice]
  end

  test "should not unpend shared account - hacker way" do
    assert_not_nil accounts(:courant_benoit).pending_user
    delete_unpend  :courant_benoit

    assert_redirected_to dashboard_url
    assert_not_nil       accounts(:courant_benoit).reload.pending_user
  end

  test "should not unpend shared account - unknow account" do
    delete "/accounts/#{Account.maximum(:id) + 1}/unlink"

    assert_redirected_to dashboard_url
  end

  ########################################################################################### POST /accounts/:id/sharing
  test "should share an account" do
    login_as :benoit

    assert_not_nil accounts(:thomas_account_waiting_benoit).pending_user
    assert_equal   1, accounts(:thomas_account_waiting_benoit).users.count
    post_sharing   :thomas_account_waiting_benoit

    assert_nil           accounts(:thomas_account_waiting_benoit).reload.pending_user
    assert_equal         2, accounts(:thomas_account_waiting_benoit).reload.users.count
    assert_redirected_to accounts_path
    assert_equal         I18n.t(
      "accounts.sharing.successfully_sharing", account: accounts(:thomas_account_waiting_benoit).name
    ), flash[:notice]
  end

  test "should not share an account - hacker way" do
    assert_not_nil accounts(:courant_benoit).pending_user
    assert_equal   1, accounts(:courant_benoit).users.count
    post_sharing   :courant_benoit

    assert_not_nil       accounts(:courant_benoit).reload.pending_user
    assert_equal         1, accounts(:courant_benoit).reload.users.count
    assert_redirected_to accounts_path
    assert_equal         I18n.t("accounts.sharing.cant_sharing", account: accounts(:courant_benoit).name),
                         flash[:warning]
  end

  test "should not share an account - unknow account" do
    post "/accounts/#{Account.maximum(:id) + 1}/sharing"

    assert_redirected_to dashboard_url
  end

  ####################################################################################### DELETE /accounts/:id/unsharing
  test "should unshare an account" do
    login_as :benoit

    assert_not_nil   accounts(:thomas_account_waiting_benoit).pending_user
    assert_equal     1, accounts(:thomas_account_waiting_benoit).users.count
    delete_unsharing :thomas_account_waiting_benoit

    assert_nil           accounts(:thomas_account_waiting_benoit).reload.pending_user
    assert_equal         1, accounts(:thomas_account_waiting_benoit).reload.users.count
    assert_redirected_to accounts_path
    assert_equal         I18n.t(
      "accounts.unsharing.successfully_unsharing", account: accounts(:thomas_account_waiting_benoit).name
    ), flash[:notice]
  end

  test "should not unshare an account - hacker way" do
    assert_not_nil   accounts(:courant_benoit).pending_user
    assert_equal     1, accounts(:courant_benoit).users.count
    delete_unsharing :courant_benoit

    assert_not_nil       accounts(:courant_benoit).reload.pending_user
    assert_equal         1, accounts(:courant_benoit).reload.users.count
    assert_redirected_to accounts_path
    assert_equal         I18n.t(
      "accounts.unsharing.cant_unsharing", account: accounts(:courant_benoit).name
    ), flash[:warning]
  end

  test "should not unshare an account - unknow account" do
    delete "/accounts/#{Account.maximum(:id) + 1}/unsharing"

    assert_redirected_to dashboard_url
  end

  private ##############################################################################################################

    def get_edit(account)
      get "/accounts/#{accounts(account).id}/edit"
    end

    def patch_update(account)
      @previous_account_name = accounts(account).name

      patch "/accounts/#{accounts(account).id}", params: { account: { name:            SecureRandom.hex,
                                                                      initial_balance: rand(-100..100),
                                                                      hidden:          true_or_false } }
    end

    def delete_destroy(account)
      delete "/accounts/#{accounts(account).id}"
    end

    def delete_unlink(account)
      delete "/accounts/#{accounts(account).id}/unlink"
    end

    def delete_unpend(account)
      delete "/accounts/#{accounts(account).id}/unpend"
    end

    def post_sharing(account)
      post "/accounts/#{accounts(account).id}/sharing"
    end

    def delete_unsharing(account)
      delete "/accounts/#{accounts(account).id}/unsharing"
    end
end
