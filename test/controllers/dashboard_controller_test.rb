require 'test_helper'

class DashboardControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_select 'title', "Smoothie Funds"
    assert_select 'ul.nav:nth-child(2) > li:nth-child(1) > a:nth-child(1)', @user.name
    assert_select 'ul.nav:nth-child(2) > li:nth-child(2) > a:nth-child(1)',
                                    I18n.translate('layouts.application.logout')
  end
end
