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

  # As a logged user,
  # I want to access pages without params
  # so that I will be redirected to the dashboard path, except for the dashboard path
  test "GET pages without params" do
    connect_thomas

    # sessions#new
    get login_path
    assert_redirected_to dashboard_url

    # dashboard#index
    get dashboard_path
    assert_response :success
  end

  # As a not logged user knowing an user id
  # I want to access pages with this params
  # so that I will be redirected to the login path
  # test "GET knowing user id" do
  #   user = users(:thomas)

  #   # accounts#index
  #   get user_accounts_path user
  #   assert_redirected_to login_url

  #   # accounts#new
  #   get new_user_account_path user
  #   assert_redirected_to login_url

  #   # users#edit
  #   get edit_user_path user
  #   assert_redirected_to login_url
  # end

  # As a not logged user knowing all the ids
  # I want to access pages with this params
  # so that I will be redirected to the login path, except for the new user path
  # test "GET knowing all ids" do
  #   user = users(:thomas)
  #   accounts = user.accounts.active

  #   accounts.each do |account|
  #     # categories#index
  #     get user_account_categories_path        user, account
  #     assert_redirected_to login_url

  #     # categories#new
  #     get new_user_account_category_path      user, account
  #     assert_redirected_to login_url

  #     # categories#edit
  #     account.categories.each do |category|
  #       get edit_user_account_category_path user, account, category
  #       assert_redirected_to login_url
  #     end

  #     # transactions#index
  #     get user_account_transactions_path      user, account
  #     assert_redirected_to login_url

  #     # transactions#new
  #     get new_user_account_transaction_path   user, account
  #     assert_redirected_to login_url

  #     # transactions#edit
  #     account.transactions.each do |transaction|
  #       get edit_user_account_transaction_path user, account, transaction
  #       assert_redirected_to login_url
  #     end

  #     # schedules#index
  #     get user_account_schedules_path         user, account
  #     assert_redirected_to login_url

  #     # schedules#new
  #     get new_user_account_schedule_path      user, account
  #     assert_redirected_to login_url

  #     # schedules#edit
  #     account.schedules.each do |schedule|
  #       get edit_user_account_schedule_path user, account, schedule
  #       assert_redirected_to login_url
  #     end

  #     # accounts#edit
  #     get edit_user_account_path              user, account
  #     assert_redirected_to login_url

  #     # users#new
  #     get new_user_path                       user, account
  #     assert_response :success
  #   end
  # end

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

  # As a not logged user,
  # I want to create an user and connect myself
  # so that I will be redirected to the dashboard url
  # test "POST create and log user" do
  #   email     = "john.doe@email.com"
  #   password  = "unbreakablePassword"

  #   # users#create
  #   assert_difference('User.count') do
  #     post users_path, user: {  email: email,
  #                               password: password,
  #                               password_confirmation: password }
  #     assert_redirected_to login_url
  #   end

  #   # sessions#create
  #   post login_path, email: email, password: password
  #   assert_redirected_to dashboard_url
  # end

  # As a not logged user,
  # I want to post data
  # so that I will be redirected to the login path and data will not be created
  # test "POST knowing all ids" do
  #   user = users(:thomas)
  #   accounts = user.accounts.active

  #   accounts.each do |account|
  #     # categories#create
  #     assert_no_difference 'Category.count' do
  #       post user_account_categories_path user, account, category: { name: SecureRandom.hex }
  #       assert_redirected_to login_url
  #     end

  #     # transactions#create
  #     assert_no_difference 'Transaction.count' do
  #       post user_account_transactions_path user,
  #                                           account,
  #                                           transaction: {  category_id:  account.categories.shuffle,
  #                                                           date:         DateTime.now,
  #                                                           amount:       rand(-500.00..500.00),
  #                                                           checked:      rand(0..1) == 1 ? true : false,
  #                                                           comment:      SecureRandom.hex }
  #       assert_redirected_to login_url
  #     end

  #     # schedules#create
  #     assert_no_difference 'Schedule.count' do
  #       post user_account_schedules_path  user,
  #                                         account,
  #                                         schedule: { next_time:  DateTime.now,
  #                                                     frequency:  rand(1..10),
  #                                                     period:     ["days","weeks","months","years"].shuffle,
  #                                                     operation_attributes: { amount:   rand(-500.00..500.00),
  #                                                                             category_id: account.categories.shuffle,
  #                                                                             comment:  SecureRandom.hex,
  #                                                                             checked:  rand(0..1) == 1 ? true : false } }
  #       assert_redirected_to login_url
  #     end
  #   end

  #   # accounts#create
  #   assert_no_difference 'Account.count' do
  #     post user_accounts_path user, account: {  name:             SecureRandom.hex,
  #                                               initial_balance:  rand(-100..100),
  #                                               hidden:           false }
  #     assert_redirected_to login_url
  #   end
  # end

  # As a not logged user,
  # I want to post data via specific routes
  # so that I will be redirected to the login path and data will not be created
  # test "POST specific routes" do
  #   user = users(:thomas)
  #   accounts = user.accounts.active

  #   accounts.each do |account|
  #     # categories#import_from
  #     assert_no_difference 'Category.count' do
  #       post import_from_user_account_categories_path user, account
  #       assert_redirected_to login_url
  #     end

  #     # transactions#easycheck
  #     account.transactions.each do |transaction|
  #       assert_no_difference 'transaction.checked ? 1 : 0' do
  #         post easycheck_user_account_transaction_path user, account, transaction
  #       end
  #     end

  #     # schedules#insert
  #     assert_no_difference 'Transaction.count' do
  #       account.schedules.each do |schedule|
  #         post insert_user_account_schedule_path user, account, schedule
  #         assert_redirected_to login_url
  #       end
  #     end
  #   end
  # end

  private ######################################################################

  def connect_thomas
    user = users(:thomas)
    post "/login", email: user.email, password: "secret"
    assert_redirected_to dashboard_url
  end
end
