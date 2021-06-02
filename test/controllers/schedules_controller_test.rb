# frozen_string_literal: true

require "test_helper"

# Schedules Controller Test
class SchedulesControllerTest < ActionController::TestCase
  ################################################################################## GET /accounts/:account_id/schedules
  test "should get index" do
    get_index       @some_account
    assert_response :success
  end

  test "should not get index - hacker way" do
    get_index            @some_wrong_account
    assert_redirected_to dashboard_url
  end

  test "should not get index - unknow account" do
    get_index            @unknow_account
    assert_redirected_to dashboard_url
  end

  ############################################################################## GET /accounts/:account_id/schedules/new
  test "should get new" do
    get_new         @some_account
    assert_response :success
  end

  test "should not get new - hacker way" do
    get_new              @some_wrong_account
    assert_redirected_to dashboard_url
  end

  test "should not get new - unknow account" do
    get_new              @unknow_account
    assert_redirected_to dashboard_url
  end

  ############################################################################################## GET /schedules/:id/edit
  test "should get edit" do
    get_edit        @some_schedule
    assert_response :success
  end

  test "should not get edit - hacker way" do
    get_edit             @some_wrong_schedule
    assert_redirected_to dashboard_url
  end

  test "should not get edit - unknow schedule" do
    get_edit             @unknow_schedule
    assert_redirected_to dashboard_url
  end

  ################################################################################# POST /accounts/:account_id/schedules
  test "should create schedule" do
    assert_difference("Schedule.count") do
      post_create          @some_account
      assert_redirected_to account_schedules_path @some_account
      assert_equal         I18n.t("schedules.create.successfully_created"), flash[:notice]
    end
  end

  test "should not create schedule - hacker way" do
    assert_no_difference("Schedule.count") do
      post_create          @some_wrong_account
      assert_redirected_to dashboard_url
    end
  end

  ############################################################################################# PATCH/PUT /schedules/:id
  test "should update schedule" do
    patch_update         @some_schedule
    assert_redirected_to account_schedules_path @some_account
    assert_equal         I18n.t("schedules.update.successfully_updated"), flash[:notice]
    assert_not_equal     @previous_schedule_amount, @some_schedule.reload.operation.amount
  end

  test "should not update schedule - hacker way" do
    patch_update         @some_wrong_schedule
    assert_redirected_to dashboard_url
    assert_equal         @previous_schedule_amount, @some_wrong_schedule.reload.operation.amount
  end

  ################################################################################################ DELETE /schedules/:id
  test "should destroy schedule" do
    assert_difference ["Schedule.count", "Transaction.count"], -1 do
      delete_destroy       @some_schedule
      assert_redirected_to account_schedules_path @some_account
      assert_equal         I18n.t("schedules.destroy.successfully_destroyed"), flash[:notice]
    end
  end

  test "should not destroy schedule - hacker way" do
    assert_no_difference ["Schedule.count", "Transaction.count"] do
      delete_destroy       @some_wrong_schedule
      assert_redirected_to dashboard_url
    end
  end

  ########################################################################################### POST /schedules/:id/insert
  test "should insert transaction via schedule" do
    post_insert          @some_schedule
    assert_redirected_to dashboard_url
    assert_equal         I18n.t("schedules.insert.successfully_inserted"), flash[:notice]
    assert_not_equal     @previous_next_time, @some_schedule.reload.next_time
  end

  test "should not insert transaction via schedule - hacker way" do
    post_insert          @some_wrong_schedule
    assert_redirected_to dashboard_url
    assert_equal         @previous_next_time, @some_wrong_schedule.reload.next_time
  end

  private ##############################################################################################################

    def get_index(account)
      get :index, params: { account_id: account }
    end

    def get_new(account)
      get :new, params: { account_id: account }
    end

    def get_edit(schedule)
      get :edit, params: { id: schedule }
    end

    def post_create(account)
      post :create, params: {
        account_id: account,
        schedule:   schedule_attributes(account.categories.sample)
      }
    end

    def patch_update(schedule)
      @previous_schedule_amount = schedule.operation.amount
      patch :update, params: {
        id:       schedule,
        schedule: schedule_attributes(schedule.account.categories.sample)
      }
    end

    def schedule_attributes(category)
      { next_time:            Time.zone.now,
        frequency:            rand(1..10),
        period:               %w[days weeks months years].sample,
        operation_attributes: { category_id: category,
                                amount:      rand(-500.00..500.00),
                                comment:     SecureRandom.hex,
                                checked:     rand(0..1) == 1 } }
    end

    def delete_destroy(schedule)
      delete :destroy, params: { id: schedule }
    end

    def post_insert(schedule)
      @previous_next_time = schedule.next_time
      post :insert, params: { id: schedule }
    end
end
