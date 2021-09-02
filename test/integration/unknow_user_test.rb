# frozen_string_literal: true

require "test_helper"

# Unknow User Test
class UnknowUserTest < ActionDispatch::IntegrationTest
  fixtures :users

  setup do
    # to get session[:user_id]
    post login_url, params: { email: users(:thomas).email, password: "p@ssw0rd!" }
  end

  ############################################################################################################### DELETE

  # As a not logged user,
  # I want to delete data
  # so that I will be redirected to the login path and data will not be deleted
  test "DELETE data knowing all ids" do
    user = User.find session[:user_id]

    # sessions#destroy
    delete logout_url
    assert_redirected_to login_url

    user.accounts.active.each do |account|
      # categories#destroy
      assert_no_difference "Category.count" do
        account.categories.each do |category|
          delete category_path category
          assert_redirected_to login_url
        end
      end

      # transactions#destroy
      assert_no_difference "Transaction.count" do
        account.transactions.each do |transaction|
          delete transaction_path transaction
          assert_redirected_to login_url
        end
      end

      # schedules#destroy
      assert_no_difference "Schedule.count" do
        account.schedules.each do |schedule|
          delete schedule_path schedule
          assert_redirected_to login_url
        end
      end

      # accounts#destroy
      assert_no_difference "Account.count" do
        delete account_path account
        assert_redirected_to login_url
      end
    end

    # # users#destroy
    User.all.each do |current_user|
      assert_no_difference(
        ["User.count", "Search.count", "Schedule.count", "Transaction.count", "Category.count", "PendingUser.count",
         "Relation.count", "Account.count"]
      ) do
        delete               user_path(current_user)
        assert_redirected_to login_url
      end
    end
  end

  ################################################################################################################## GET

  # As a not logged user,
  # I want to access pages without params
  # so that I will be redirected to the login path, except for the login path
  test "GET pages without params" do
    delete logout_url

    # sessions#new
    get login_path
    assert_response :success

    # dashboard#index
    get dashboard_path
    assert_redirected_to login_url
  end

  # As a not logged user knowing an user id
  # I want to access pages with this params
  # so that I will be redirected to the login path
  test "GET knowing user id" do
    user = User.find session[:user_id]

    delete logout_url

    # accounts#index
    get accounts_path
    assert_redirected_to login_url

    # accounts#new
    get new_account_path
    assert_redirected_to login_url

    # users#edit
    get edit_user_path user
    assert_redirected_to login_url
  end

  # As a not logged user knowing all the ids
  # I want to access pages with this params
  # so that I will be redirected to the login path, except for the new user path
  test "GET knowing all ids" do
    user = User.find session[:user_id]

    delete logout_url

    user.accounts.active.each do |account|
      # categories#index
      get account_categories_path account
      assert_redirected_to login_url

      # categories#new
      get new_account_category_path account
      assert_redirected_to login_url

      # categories#edit
      account.categories.each do |category|
        get edit_category_path category
        assert_redirected_to login_url
      end

      # transactions#index
      get account_transactions_path account
      assert_redirected_to login_url

      # transactions#new
      get new_account_transaction_path account
      assert_redirected_to login_url

      # transactions#edit
      account.transactions.each do |transaction|
        get edit_transaction_path transaction
        assert_redirected_to login_url
      end

      # schedules#index
      get account_schedules_path account
      assert_redirected_to login_url

      # schedules#new
      get new_account_schedule_path account
      assert_redirected_to login_url

      # schedules#edit
      account.schedules.each do |schedule|
        get edit_schedule_path schedule
        assert_redirected_to login_url
      end

      # accounts#edit
      get edit_account_path account
      assert_redirected_to login_url

      # users#new
      get new_user_path user, account
      assert_response :success
    end
  end

  ########################################################################################################## PATCH / PUT

  # As a not logged user,
  # I want to patch data
  # so that I will be redirected to the login path and data will not be updated
  test "PATCH data knowing all ids" do
    user = User.find session[:user_id]

    delete logout_url

    user.accounts.active.each do |account|
      # categories#update
      account.categories.each do |category|
        assert_no_difference "category.name.sum" do
          patch category_path category, params: { name: SecureRandom.hex }
          assert_redirected_to login_url
        end
      end

      # transactions#update
      account.transactions.each do |transaction|
        assert_no_difference "transaction.amount" do
          patch transaction_path transaction, params: {
            amount: transaction.amount + 1
          }
          assert_redirected_to login_url
        end
      end

      # schedules#update
      account.schedules.each do |schedule|
        assert_no_difference "schedule.frequency" do
          patch schedule_path schedule, params: {
            frequency: schedule.frequency + 1
          }
          assert_redirected_to login_url
        end
      end

      # accounts#update
      assert_no_difference "account.name.sum" do
        patch account_path account, params: { name: SecureRandom.hex }
        assert_redirected_to login_url
      end
    end

    # users#update
    assert_no_difference "user.email.sum" do
      patch user_path user, params: { email: "wrong@email.com" }
      assert_redirected_to login_url
    end
  end

  ################################################################################################################# POST

  # As a not logged user,
  # I want to create an user and connect myself
  # so that I will be redirected to the dashboard url
  test "POST create and log user" do
    email    = "john.doe@email.com"
    password = "unbreakablePassword"

    # users#create
    assert_difference("User.count") do
      post users_path, params: { user: { email:                 email,
                                         password:              password,
                                         password_confirmation: password } }
      assert_redirected_to login_url
    end

    # sessions#create
    post                 login_path, params: { email: email, password: password }
    assert_redirected_to dashboard_url
  end

  # As a not logged user,
  # I want to post data
  # so that I will be redirected to the login path and data will not be created
  test "POST knowing all ids" do
    user     = User.find session[:user_id]
    periods  = %w[days weeks months years]

    delete logout_url

    user.accounts.active.each do |account|
      # categories#create
      assert_no_difference "Category.count" do
        post account_categories_path account, params: {
          category: {
            name: SecureRandom.hex
          }
        }
        assert_redirected_to login_url
      end

      # transactions#create
      assert_no_difference "Transaction.count" do
        post account_transactions_path account, params: {
          transaction: { category_id: account.categories.sample,
                         date:        Time.zone.now,
                         amount:      rand(-500.00..500.00),
                         checked:     true_or_false,
                         comment:     SecureRandom.hex }
        }
        assert_redirected_to login_url
      end

      # schedules#create
      assert_no_difference "Schedule.count" do
        post account_schedules_path account, params: {
          schedule: { next_time:            Time.zone.now,
                      frequency:            rand(1..10),
                      period:               periods.sample,
                      operation_attributes: {
                        amount:      rand(-500.00..500.00),
                        category_id: account.categories.sample,
                        comment:     SecureRandom.hex,
                        checked:     true_or_false
                      } }
        }
        assert_redirected_to login_url
      end
    end

    # accounts#create
    assert_no_difference "Account.count" do
      post accounts_path, params: {
        account: { name:            SecureRandom.hex,
                   initial_balance: rand(-100..100),
                   idden:           false }
      }
      assert_redirected_to login_url
    end
  end

  # As a not logged user,
  # I want to post data via specific routes
  # so that I will be redirected to the login path and data will not be created
  test "POST specific routes" do
    user = User.find session[:user_id]

    delete logout_url

    user.accounts.active.each do |account|
      # categories#import_from
      assert_no_difference "Category.count" do
        post import_from_account_categories_path user, account
        assert_redirected_to login_url
      end

      # transactions#easycheck
      account.transactions.each do |transaction|
        assert_no_difference "transaction.checked ? 1 : 0" do
          post easycheck_transaction_path transaction
        end
      end

      # schedules#insert
      assert_no_difference "Transaction.count" do
        account.schedules.each do |schedule|
          post insert_schedule_path schedule
          assert_redirected_to login_url
        end
      end
    end
  end
end
