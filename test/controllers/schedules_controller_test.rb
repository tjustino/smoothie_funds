# frozen_string_literal: true

require "test_helper"

# Schedules Controller Test
class SchedulesControllerTest < ActionDispatch::IntegrationTest
  setup { login_as :thomas }

  ################################################################################## GET /accounts/:account_id/schedules
  test "should get index" do
    get_index some_account_for(:thomas)

    assert_response :success
  end

  test "should not get index - hacker way" do
    get_index some_account_for(:emilie)

    assert_redirected_to dashboard_url
  end

  test "should not get index - unknow account" do
    get "/accounts/#{Account.maximum(:id) + 1}/schedules"

    assert_redirected_to dashboard_url
  end

  ############################################################################## GET /accounts/:account_id/schedules/new
  test "should get new" do
    get_new some_account_for(:thomas)

    assert_response :success
  end

  test "should not get new - hacker way" do
    get_new some_account_for(:emilie)

    assert_redirected_to dashboard_url
  end

  test "should not get new - unknow account" do
    get "/accounts/#{Account.maximum(:id) + 1}/schedules/new"

    assert_redirected_to dashboard_url
  end

  ############################################################################################## GET /schedules/:id/edit
  test "should get edit" do
    get_edit some_schedule_for(:thomas)

    assert_response :success
  end

  test "should not get edit - hacker way" do
    get_edit some_schedule_for(:emilie)

    assert_redirected_to dashboard_url
  end

  test "should not get edit - unknow schedule" do
    get "/schedules/#{Schedule.maximum(:id) + 1}/edit"

    assert_redirected_to dashboard_url
  end

  ################################################################################# POST /accounts/:account_id/schedules
  test "should create schedule" do
    assert_difference("Schedule.count") do
      account = some_account_for(:thomas)
      post_create account

      assert_redirected_to account_schedules_path(account)
      assert_equal         I18n.t("schedules.create.successfully_created"), flash[:notice]
    end
  end

  test "should not create schedule - hacker way" do
    assert_no_difference("Schedule.count") do
      post_create some_account_for(:emilie)

      assert_redirected_to dashboard_url
    end
  end

  ############################################################################################# PATCH/PUT /schedules/:id
  test "should update schedule" do
    schedule = some_schedule_for(:thomas)
    patch_update schedule

    assert_redirected_to account_schedules_path(schedule.account)
    assert_equal         I18n.t("schedules.update.successfully_updated"), flash[:notice]
    assert_not_equal     @previous_schedule_amount, schedule.reload.operation.amount
  end

  test "should not update schedule - hacker way" do
    wrong_schedule = some_schedule_for(:emilie)
    patch_update wrong_schedule

    assert_redirected_to dashboard_url
    assert_equal         @previous_schedule_amount, wrong_schedule.reload.operation.amount
  end

  ################################################################################################ DELETE /schedules/:id
  test "should destroy schedule" do
    assert_difference [ "Schedule.count", "Transaction.count" ], -1 do
      schedule = some_schedule_for(:thomas)
      schedule_account = schedule.account
      delete_destroy schedule

      assert_redirected_to account_schedules_path(schedule_account)
      assert_equal         I18n.t("schedules.destroy.successfully_destroyed"), flash[:notice]
    end
  end

  test "should not destroy schedule - hacker way" do
    assert_no_difference [ "Schedule.count", "Transaction.count" ] do
      delete_destroy some_schedule_for(:emilie)

      assert_redirected_to dashboard_url
    end
  end

  ########################################################################################### POST /schedules/:id/insert
  test "should insert transaction via schedule" do
    schedule = some_schedule_for(:thomas)
    post_insert schedule

    assert_redirected_to dashboard_url
    assert_equal         I18n.t("schedules.insert.successfully_inserted"), flash[:notice]
    assert_not_equal     @previous_next_time, schedule.reload.next_time
  end

  test "should not insert transaction via schedule - hacker way" do
    wrong_schedule = some_schedule_for(:emilie)
    post_insert wrong_schedule

    assert_redirected_to dashboard_url
    assert_equal         @previous_next_time, wrong_schedule.reload.next_time
  end

  private ##############################################################################################################

    def get_index(account)
      get "/accounts/#{account.id}/schedules"
    end

    def get_new(account)
      get "/accounts/#{account.id}/schedules/new"
    end

    def get_edit(schedule)
      get "/schedules/#{schedule.id}/edit"
    end

    def post_create(account)
      post "/accounts/#{account.id}/schedules", params: { schedule: schedule_attributes(some_category_for(account)) }
    end

    def patch_update(schedule)
      @previous_schedule_amount = schedule.operation.amount
      patch "/schedules/#{schedule.id}", params: { schedule: schedule_attributes(schedule.account.categories.sample) }
    end

    def schedule_attributes(category)
      { next_time:            Time.zone.now,
        frequency:            rand(1..10),
        period:               %w[days weeks months years].sample,
        operation_attributes: { category_id: category.id,
                                amount:      rand(-500.00..500.00),
                                comment:     SecureRandom.hex,
                                checked:     true_or_false } }
    end

    def delete_destroy(schedule)
      delete "/schedules/#{schedule.id}"
    end

    def post_insert(schedule)
      @previous_next_time = schedule.next_time
      post "/schedules/#{schedule.id}/insert"
    end
end
