# frozen_string_literal: true

require "test_helper"

# Analytics Controller Test
class AnalyticsControllerTest < ActionController::TestCase
  ######################################################################################## GET /users/:user_id/analytics
  test "should get index" do
    get             :index, params: { user_id: @user }
    assert_response :success
    assert_select   "h2", I18n.t("analytics.index.tendency")
    @accounts.order(name: :asc).each_with_index do |account, index|
      assert_select "#account#{index}", account.name
    end
  end
end
