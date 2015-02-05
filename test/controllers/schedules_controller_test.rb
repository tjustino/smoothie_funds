require 'test_helper'

class SchedulesControllerTest < ActionController::TestCase
  # GET /users/1/accounts/1/schedules
  test "should get index" do
    @accounts.each do |account|
      get :index, user_id: @user, account_id: account
      assert_response :success
      assert_not_nil assigns(:schedules)
    end
  end

  # GET /users/1/accounts/1/schedules/new
  test "should get new" do
    @accounts.each do |account|
      get :new, user_id: @user, account_id: account
      assert_response :success
    end
  end

  # GET /users/1/accounts/1/schedules/1/edit
  test "should get edit" do
    @accounts.each do |account|
      account.schedules.each do |schedule|
        get :edit, user_id: @user, account_id: account, id: schedule
        assert_response :success
      end
    end
  end

  # POST /users/1/accounts/1/schedules
  test "should create schedule" do
    @accounts.each do |account|
      #TODO fix problem with assert_difference
      #assert_difference ['Schedule.count', 'Transaction.count'] do
        post :create, user_id:    @user, 
                      account_id: account,
                      schedule: { next_time:  DateTime.now,
                                  frequency:  rand(1..10),
                                  period:     ["days","weeks","months","years"].sample,
                                  operation_attributes: { amount:   rand(-500.00..500.00),
                                                          category_id: account.categories.sample,
                                                          comment:  SecureRandom.hex,
                                                          checked:  rand(0..1) == 1 ? true : false } }

        assert_redirected_to user_account_schedules_path
      #end
    end
  end

  # PATCH/PUT /users/1/accounts/1/schedules/1
  test "should update schedule" do
    @accounts.each do |account|
      account.schedules.each do |schedule|
        patch :update,  user_id:    @user,
                        id:         schedule,
                        account_id: account,
                        schedule: { next_time:  DateTime.now,
                                    frequency:  rand(1..10),
                                    period:     ["days","weeks","months","years"].sample,
                                    operation_attributes: { amount:   rand(-500.00..500.00),
                                                            category_id: account.categories.sample,
                                                            comment:  SecureRandom.hex,
                                                            checked:  rand(0..1) == 1 ? true : false } }

        assert_redirected_to user_account_schedules_path
      end
    end
  end

  # DELETE /users/1/accounts/1/schedules/1
  test "should destroy schedule" do
    @accounts.each do |account|
      account.schedules.each do |schedule|
        #TODO fix problem with assert_difference
        #assert_difference ['Schedule.count', 'Transaction.count'], -1 do
          delete :destroy, user_id: @user, account_id: account, id: schedule
        #end

        assert_redirected_to user_account_schedules_path
      end
    end
  end

  # POST /users/1/accounts/1/schedules/1/insert
  test "should insert transaction" do
    @accounts.each do |account|
      account.schedules.each do |schedule|
        request.env['HTTP_REFERER'] = "/previous_link_url"

        assert_difference 'Transaction.count' do
          post :insert, user_id: @user, account_id: account, id: schedule
        end

        assert_redirected_to request.env['HTTP_REFERER']
      end
    end
  end
end
