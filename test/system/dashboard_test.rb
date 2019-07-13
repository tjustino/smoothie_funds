# frozen_string_literal: true

require "application_system_test_case"

class DashboardTest < ApplicationSystemTestCase
  setup do
    @user = users(:thomas)
    # login_as @user
    #
    visit login_url
    fill_in I18n.translate("sessions.new.email"), with: @user.email
    fill_in I18n.translate("sessions.new.password"), with: "secret"
    click_on I18n.translate("sessions.new.login")
  end

  test "visiting the dashboard" do
    visit dashboard_url
    assert_selector "h1", text: I18n.translate("dashboard.index.dashboard")
  end

  # test "creating a Cart" do
  #   visit carts_url
  #   click_on "New Cart"
  #
  #   click_on "Create Cart"
  #
  #   assert_text "Cart was successfully created"
  #   click_on "Back"
  # end
  #
  # test "updating a Cart" do
  #   visit carts_url
  #   click_on "Edit", match: :first
  #
  #   click_on "Update Cart"
  #
  #   assert_text "Cart was successfully updated"
  #   click_on "Back"
  # end
  #
  # test "destroying a Cart" do
  #   visit carts_url
  #   page.accept_confirm do
  #     click_on "Destroy", match: :first
  #   end
  #
  #   assert_text "Cart was successfully destroyed"
  # end
end
