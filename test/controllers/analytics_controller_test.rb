require 'test_helper'

class AnalyticsControllerTest < ActionController::TestCase
  ################################################ GET /users/:user_id/analytics
  test "should get index" do
    get             :index, params: { user_id: @user }
    assert_response :success
    assert_select   "h1", I18n.translate('analytics.index.analytics')
    @accounts.order(name: :asc).each_with_index do |account, index|
      assert_select "#heading#{index} > h2:nth-child(1) > a:nth-child(1)", account.name
    end
  end
end
