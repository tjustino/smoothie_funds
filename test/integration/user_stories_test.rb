require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  # As a new user,
  # I want to create an account
  # so that I can connect myself to the app
  test "create new user and login" do
    email     = "john.doe@email.com"
    password  = "unbreakablePassword"

    # create a new user 
    get "/users/new"
    assert_response :success
    assert_template "users/new"

    assert_difference('User.count') do
      post "/users", user: {  email: email,
                              name: "John Doe",
                              password: password,
                              password_confirmation: password }
    end

    follow_redirect!
    assert_response :success

    assert_template "sessions/new"
    assert_select ".alert-success", I18n.translate('users.create.successfully_created')

    # login with this user
    post "/login", email: email, password: password
    follow_redirect!

    assert_response :success
    assert_template "dashboard/index"
  end

  # As a not logged user,
  # I can't go anyway and see anything
  # so that I will be redirected to the login page anytime I do mistake
  test "redirect not logged user" do
    get login_path
    assert_select ".navbar-nav", false

    # dashboard
    get dashboard_path
    assert_redirected_to login_path
    
    # users
    User.all.each do |user|
      get edit_user_path(user)
      assert_redirected_to login_path
    end

    # accounts
    User.all.each do |user|
      user.accounts.each do |account|
        get user_accounts_path(user, account)
        assert_redirected_to login_path

        get new_user_account_path(user, account)
        assert_redirected_to login_path

        get edit_user_account_path(user, account)
        assert_redirected_to login_path
      end
    end

    # categories
    User.all.each do |user|
      user.accounts.each do |account|
        account.categories.each do |category|
          get user_account_categories_path(user, account, category)
          assert_redirected_to login_path

          get new_user_account_category_path(user, account, category)
          assert_redirected_to login_path

          get edit_user_account_category_path(user, account, category)
          assert_redirected_to login_path
        end
      end
    end

    # transactions
    User.all.each do |user|
      user.accounts.each do |account|
        account.transactions.each do |transaction|
          get user_account_transactions_path(user, account, transaction)
          assert_redirected_to login_path

          get new_user_account_transaction_path(user, account, transaction)
          assert_redirected_to login_path

          get edit_user_account_transaction_path(user, account, transaction)
          assert_redirected_to login_path
        end
      end
    end
  end

  # As a logged user,
  # I can't access data that not mine
  # so that I will be redirected to the correct page anytime I do mistake
  test "redirect logged user" do
    good_user   = users(:thomas)
    wrong_user  = users(:emilie)
    hacked_name = "Hacked Name"

    # login
    get login_path
    post "/login", email: good_user.email, password: "secret"
    follow_redirect!
    assert_response :success
    assert_template "dashboard/index"

    # want to edit another user
    get edit_user_path(good_user.id)
    assert_response :success
    assert_template "users/edit"

    get edit_user_path(wrong_user.id)
    assert_redirected_to edit_user_path(good_user.id)

    # want to edit another account
    get user_accounts_path(good_user)
    assert_response :success
    assert_template "accounts/index"

    ## index
    get user_accounts_path(wrong_user)
    assert_select "ul.nav:nth-child(2) > li:nth-child(1) > a:nth-child(1)", good_user.name

    ## create
    post user_accounts_path(wrong_user),  user_id: session[:user_id],
                                          account: {  name: hacked_name,
                                                      initial_balance: 12.34 }
    follow_redirect!
    assert_response :success
    assert_select "ul.nav:nth-child(2) > li:nth-child(1) > a:nth-child(1)", good_user.name
    assert good_user.accounts.where(name: hacked_name).any?
    assert wrong_user.accounts.where(name: hacked_name).empty?

    ## update
    patch user_account_path(wrong_user, wrong_user.accounts.sample), 
                                              user_id: session[:user_id],
                                              account: {  name: hacked_name.reverse,
                                                          initial_balance: 666 }
    follow_redirect!
    assert_response :success
    assert_select "ul.nav:nth-child(2) > li:nth-child(1) > a:nth-child(1)", good_user.name
    #assert good_user.accounts.where(name: hacked_name.reverse).empty?
    #puts Account.where(name: hacked_name.reverse).first.users.first.name
    #assert wrong_user.accounts.where(name: hacked_name.reverse).empty?
    #puts wrong_user.accounts.where(name: hacked_name.reverse).first.initial_balance
  end
end
