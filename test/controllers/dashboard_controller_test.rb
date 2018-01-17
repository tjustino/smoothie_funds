require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  ######################################################################## GET /
  test "should get index" do
    get             :index
    assert_response :success
    assert_select   "title", "Smoothie Funds"
    assert_select   "#logout", I18n.translate('layouts.application.logout')
    # assert_not_nil  assigns(:transactions)
    # assert_not_nil  assigns(:current_transactions)
    # assert_not_nil  assigns(:schedules)
  end
end
