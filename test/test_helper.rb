ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :users, :accounts, :categories, :transactions, :schedules

  # Add more helper methods to be used by all tests here...
  def setup
    session[:user_id]       = users(:thomas).id if defined? session

    @user                   = users(:thomas)
    @accounts               = @user.accounts.active
    @some_account           = @accounts.sample
    until @some_account.schedules.exists?
      @some_account         = @accounts.sample
    end
    @some_category          = @some_account.categories.sample
    @some_schedule          = @some_account.schedules.sample
    @some_transaction       = @some_account.transactions.sample

    @wrong_user             = users(:emilie)
    @wrong_accounts         = @wrong_user.accounts.active.where.not(id: accounts(:compte_commun))
    @some_wrong_account     = @wrong_accounts.sample
    until @some_wrong_account.schedules.exists?
      @some_wrong_account   = @wrong_accounts.sample
    end
    @some_wrong_category    = @some_wrong_account.categories.sample
    @some_wrong_schedule    = @some_wrong_account.schedules.sample
    @some_wrong_transaction = @some_wrong_account.transactions.sample

    @unknow_account         = Account.maximum(:id)      + 1
    @unknow_category        = Category.maximum(:id)     + 1
    @unknow_schedule        = Schedule.maximum(:id)     + 1
    @unknow_transaction     = Transaction.maximum(:id)  + 1
  end

  def logout
    session.delete :user_id
  end
end
