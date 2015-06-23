require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  ######################################################################## GET /
  test "should get index" do
    get             :index
    assert_response :success
    assert_select   "title", "Smoothie Funds"
    assert_select   "body > div:nth-child(1) > div.navbar.navbar-default > " +
                    "div > div.navbar-collapse.collapse > " +
                    "ul.nav.navbar-nav.navbar-right > li:nth-child(2) > a",
                    I18n.translate('layouts.application.logout')
    assert_not_nil  assigns(:transactions)
    assert_not_nil  assigns(:current_transactions)
    assert_not_nil  assigns(:schedules)
  end
end
