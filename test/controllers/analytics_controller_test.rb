# frozen_string_literal: true

require "test_helper"

# Analytics Controller Test
class AnalyticsControllerTest < ActionDispatch::IntegrationTest
  setup { login_as :thomas }

  ######################################################################################## GET /users/:user_id/analytics
  test "should get index" do
    get "/users/#{users(:thomas).id}/analytics"

    assert_response :success
    assert_select   "h2", I18n.t("analytics.index.tendency")
    users(:thomas).accounts.active.order(name: :asc).each_with_index do |account, index|
      assert_select "#account#{index}", account.name
    end
  end
end
