# frozen_string_literal: true

require "application_system_test_case"

# General Stories Test
class GeneralStoriesTest < ApplicationSystemTestCase
  test "visiting the index" do
    visit login_url

    assert_selector "h1", text: "Connexion"
  end
end
