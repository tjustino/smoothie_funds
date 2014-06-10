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
    assert_select ".alert-success", 
                  CGI.escapeHTML(I18n.translate('users.create.successfully_created'))
                  # 

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
  # I can't go anyway
  # so that I will be redirected to the dashboard page anytime I do mistake
  test "redirect logged user" do
    
  end
end
