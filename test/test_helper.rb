ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :users, :accounts, :categories, :transactions

  # Add more helper methods to be used by all tests here...
  def setup
    session[:user_id] = users(:thomas).id if defined? session
    @user = users(:thomas)
    @accounts   = @user.accounts
  end

  def logout
    session.delete :user_id
  end

  def wrong_user
    users(:emilie)
  end
end
