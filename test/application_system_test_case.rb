# frozen_string_literal: true

require "test_helper"

# Application System Test Case
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [1366, 768]
end
