# frozen_string_literal: true

require "test_helper"

# Dashboard Controller Test
class DashboardControllerTest < ActionController::TestCase
  ################################################################################################################ GET /
  test "should get index" do
    get             :index
    assert_response :success
    assert_select   "title", "Smoothie Funds"
    assert_select   "#logout", I18n.t("layouts.application.logout")
  end
end
