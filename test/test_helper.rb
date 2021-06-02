# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
require "rails/test_help"

module ActiveSupport
  # TestCase superclass
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for tests in alphabetical order
    fixtures :users,
             :accounts,
             :categories,
             :transactions,
             :schedules,
             :pending_users # , :searches

    # Add more helper methods to be used by all tests here...
    def setup
      session[:user_id] = users(:thomas).id if defined? session

      user_use_cases
      account_use_cases
      category_use_cases
      schedule_use_cases
      transaction_use_cases
      search_use_cases
    end

    def logout
      session.delete :user_id
    end

    private

      def user_use_cases
        @user               = users(:thomas)
        @wrong_user         = users(:emilie)
        @some_pending_user  = PendingUser.all.sample
        @unknow_user        = User.maximum(:id).to_i + 1
      end

      def account_use_cases
        some_account
        some_wrong_account
        @unknow_account = Account.maximum(:id).to_i + 1
      end

      def some_account
        @accounts     = @user.accounts.active
        @some_account = @accounts.where(id: @user.schedules.select(:account_id)).sample
      end

      def some_wrong_account
        @wrong_accounts = @wrong_user.accounts.active.where.not(id: accounts(:compte_commun))
        @some_wrong_account = @wrong_accounts.where(id: @wrong_user.schedules.select(:account_id)).sample
      end

      def category_use_cases
        @some_category        = @some_account.categories.sample
        @some_wrong_category  = @some_wrong_account.categories.sample
        @unknow_category      = Category.maximum(:id).to_i + 1
      end

      def schedule_use_cases
        @some_schedule        = @some_account.schedules.sample
        @some_wrong_schedule  = @some_wrong_account.schedules.sample
        @unknow_schedule      = Schedule.maximum(:id).to_i + 1
      end

      def transaction_use_cases
        @some_transaction       = @some_account.transactions.sample
        @some_wrong_transaction = @some_wrong_account.transactions.sample
        @unknow_transaction     = Transaction.maximum(:id).to_i + 1
      end

      def search_use_cases
        @unknow_search = Search.maximum(:id).to_i + 1
      end
  end
end
