require 'test_helper'

class LoggedUserTest < ActionDispatch::IntegrationTest
  fixtures :users

  ####################################################################### DELETE

  # As a not logged user,
  # I want to delete data
  # so that I will be redirected to the login path and data will not be deleted
  # test "DELETE data knowing all ids" do
  #   user = users(:thomas)
  #   accounts = user.accounts.active

  #   # sessions#destroy
  #   delete logout_path
  #   assert_redirected_to login_url

  #   accounts.each do |account|
  #     # categories#destroy
  #     assert_no_difference 'Category.count' do
  #       account.categories.each do |category|
  #         delete user_account_category_path user, account, category
  #         assert_redirected_to login_url
  #       end
  #     end

  #     # transactions#destroy
  #     assert_no_difference 'Transaction.count' do
  #       account.transactions.each do |transaction|
  #         delete user_account_transaction_path user, account, transaction
  #         assert_redirected_to login_url
  #       end
  #     end

  #     # schedules#destroy
  #     assert_no_difference 'Schedule.count' do
  #       account.schedules.each do |schedule|
  #         delete user_account_schedule_path user, account, schedule
  #         assert_redirected_to login_url
  #       end
  #     end

  #     # accounts#destroy
  #     assert_no_difference 'Account.count' do
  #       delete user_account_path user, account
  #       assert_redirected_to login_url
  #     end
  #   end

  #   # users#destroy
  #   assert_no_difference 'User.count' do
  #     User.all.each do |user|
  #       delete user_path user
  #       assert_redirected_to login_url
  #     end
  #   end
  # end

  ########################################################################## GET

  # As a logged user
  # I want to access pages without params
  # so that I will be redirected to the dashboard path, except for the dashboard path
  test "GET pages without params" do
    user = users(:thomas)
    connect user

    # sessions#new
    get login_path
    assert_redirected_to dashboard_url

    # dashboard#index
    get dashboard_path
    assert_response :success
  end

  # As a logged user
  # I want to access pages with my user id
  # so that it will be a success
  test "GET with my id" do
    user = users(:thomas)
    connect user

    # accounts#index
    get user_accounts_path user
    assert_response :success

    # accounts#new
    get new_user_account_path user
    assert_response :success

    # users#edit
    get edit_user_path user
    assert_response :success
  end

  # As a logged user knowing all the ids
  # I want to access pages with this params
  # so that it will be a success, except for the new user path
  test "GET knowing my ids" do
    user = users(:thomas)
    accounts = user.accounts.active

    connect user

    accounts.each do |account|
      # categories#index
      get user_account_categories_path        user, account
      assert_response :success

      # categories#new
      get new_user_account_category_path      user, account
      assert_response :success

      # categories#edit
      account.categories.each do |category|
        get edit_user_account_category_path user, account, category
        assert_response :success
      end

      # transactions#index
      get user_account_transactions_path      user, account
      assert_response :success

      # transactions#new
      get new_user_account_transaction_path   user, account
      assert_response :success

      # transactions#edit
      account.transactions.each do |transaction|
        get edit_user_account_transaction_path user, account, transaction
        assert_response :success
      end

      # schedules#index
      get user_account_schedules_path         user, account
      assert_response :success

      # schedules#new
      get new_user_account_schedule_path      user, account
      assert_response :success

      # schedules#edit
      account.schedules.each do |schedule|
        get edit_user_account_schedule_path user, account, schedule
        assert_response :success
      end

      # accounts#edit
      get edit_user_account_path              user, account
      assert_response :success

      # users#new
      get new_user_path                       user, account
      assert_redirected_to dashboard_url
    end
  end

  ################################################################## PATCH / PUT

  # As a not logged user,
  # I want to patch data
  # so that I will be redirected to the login path and data will not be updated
  # test "PATCH data knowing all ids" do
  #   user = users(:thomas)
  #   accounts = user.accounts.active

  #   accounts.each do |account|
  #     # categories#update
  #     account.categories.each do |category|
  #       assert_no_difference 'category.name.sum' do
  #         patch user_account_category_path user, account, category, name: SecureRandom.hex
  #         assert_redirected_to login_url
  #       end
  #     end

  #     # transactions#update
  #     account.transactions.each do |transaction|
  #       assert_no_difference 'transaction.amount' do
  #         patch user_account_transaction_path user, account, transaction, amount: transaction.amount + 1
  #         assert_redirected_to login_url
  #       end
  #     end

  #     # schedules#update
  #     account.schedules.each do |schedule|
  #       assert_no_difference 'schedule.frequency' do
  #         patch user_account_schedule_path user, account, schedule, frequency: schedule.frequency + 1
  #         assert_redirected_to login_url
  #       end
  #     end

  #     # accounts#update
  #     assert_no_difference 'account.name.sum' do
  #       patch user_account_path user, account, name: SecureRandom.hex
  #       assert_redirected_to login_url
  #     end
  #   end

  #   # users#update
  #   assert_no_difference 'user.email.sum' do
  #     patch user_path user, email: "wrong@email.com"
  #     assert_redirected_to login_url
  #   end
  # end

  ######################################################################### POST

  # As a logged user,
  # I want to create an user and connect myself
  # so that I will be redirected to the dashboard url
  test "POST create and log user" do
    user = users(:thomas)

    # users#create
    assert_difference 'User.count' do
      post users_path, user: {  email: "john.doe@email.com",
                                password: "unbreakablePassword",
                                password_confirmation: "unbreakablePassword" }
      assert_redirected_to login_url
    end

    # sessions#create
    post login_path, email: user.email, password: "secret"
    assert_redirected_to dashboard_url
  end

  # As a logged user,
  # I want to post data
  # so that it will be a success and data will be created
  test "POST knowing my ids" do
    user = users(:thomas)
    accounts = user.accounts.active

    connect user

    accounts.each do |account|
      # categories#create
      assert_difference 'Category.count' do
        post user_account_categories_path user, 
                                          account, 
                                          category: { name: SecureRandom.hex }
        assert_redirected_to user_account_categories_url
      end

      # transactions#create
      assert_difference 'Transaction.count' do
        post user_account_transactions_path user,
                                            account,
                                            transaction: {  
                                  category_id:  account.categories.sample,
                                  date:         DateTime.now,
                                  amount:       rand(-500.00..500.00),
                                  checked:      rand(0..1) == 1 ? true : false,
                                  comment:      SecureRandom.hex }
        assert_redirected_to user_account_transactions_url
      end

      # schedules#create
      assert_difference 'Schedule.count' do
        post user_account_schedules_path  user,
                                          account,
                                          schedule: { 
              next_time:  DateTime.now,
              frequency:  rand(1..10),
              period:     ["days","weeks","months","years"].sample,
              operation_attributes: { amount:   rand(-500.00..500.00),
                                      category_id: account.categories.sample,
                                      comment:  SecureRandom.hex,
                                      checked:  rand(0..1) == 1 ? true : false }
                                                    }
        assert_redirected_to user_account_schedules_url
      end
    end

    # accounts#create
    assert_difference 'Account.count' do
      post user_accounts_path user, account: {  name:             SecureRandom.hex,
                                                initial_balance:  rand(-100..100),
                                                hidden:           false }
      assert_redirected_to user_accounts_url
    end
  end

  # As a logged user,
  # I want to post data via specific routes
  # so that it will be a success and data will be created
  test "POST specific routes" do
    user = users(:thomas)
    accounts = user.accounts.active

    connect user

    accounts.each do |account|
      # categories#import_from
      other_account = accounts.sample
      other_account = accounts.sample while account == other_account

      before = account.categories.count

      post import_from_user_account_categories_path(  user_id: user.id,
                            account_id: account.id,
                            account: { "categories" => other_account.id.to_s } )

      assert_redirected_to user_account_categories_url

      after = account.categories.reload.count
      assert_not_equal before, after

      # transactions#easycheck
      account.transactions.each do |transaction|
        before = transaction.checked

        post easycheck_user_account_transaction_path( user, 
                                                      account,
                                                      transaction ), nil,
              { "HTTP_REFERER" => "http://www.example.com/previous_link_url" }
        assert_redirected_to :back

        after = transaction.reload.checked
        assert_not_equal before, after
      end

      # schedules#insert
      account.schedules.each do |schedule|
        assert_difference 'Transaction.count' do
          post insert_user_account_schedule_path( user,
                                                  account,
                                                  schedule ), nil,
              { "HTTP_REFERER" => "http://www.example.com/previous_link_url" }
          assert_redirected_to :back
        end
      end
    end
  end

  private ######################################################################

  def connect(user)
    post "/login", email: user.email, password: "secret"
    assert_redirected_to dashboard_url
  end
end
