# frozen_string_literal: true

require "test_helper"

# Rights Controller Test
class RightsControllerTest < ActionController::TestCase
  ########################################################################################################### GET /terms
  test "should get terms for everyone" do
    get             :terms
    assert_response :success
    logout
    get             :terms
    assert_response :success
  end

  ########################################################################################################## GET /cookie
  test "should get cookie for everyone" do
    get             :cookie
    assert_response :success
    logout
    get             :cookie
    assert_response :success
  end

  ############################################################################################################ GET /gdpr
  test "should get gdpr for everyone" do
    get             :gdpr
    assert_response :success
    logout
    get             :gdpr
    assert_response :success
  end
end
