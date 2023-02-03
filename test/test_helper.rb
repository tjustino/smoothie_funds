# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  # TestCase superclass
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for tests in alphabetical order
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def login_as(name)
      post "/login", params: { email: users(name).email, password: "p@ssw0rd!" }
    end

    def logout
      delete "/logout"
    end

    def true_or_false
      rand(0..1) == 1
    end

    def some_account_for(user)
      # let's chosse active account, with schedules and don't forget to avoid joint accounts
      account_with_schedules = users(user).schedules.select(:account_id)
      users(user).accounts.active.where(id: account_with_schedules).where.not(id: joint_acounts).sample
    end

    def some_accounts_for(user)
      right_accounts_ids = users(user).accounts.active.where(id: users(user).schedules.select(:account_id)).ids
      max_number_of_accounts = right_accounts_ids.size
      random_number_of_accounts = rand(1..max_number_of_accounts)
      right_accounts_ids.sample(random_number_of_accounts)
    end

    def some_categories_for(accounts)
      categories_ids = Category.where(account_id: accounts).ids
      max_number_of_categories = categories_ids.size
      random_number_of_categories = rand(1..max_number_of_categories)
      categories_ids.sample(random_number_of_categories)
    end

    def some_transaction_for(user)
      # let's choose transaction that is ot part of a schedule and don't forget to avoid joint accounts
      users(user).transactions.where(schedule_id: nil).where.not(account: joint_acounts).sample
    end

    def some_category_for(account)
      # let's choose a not hideen category
      account.categories.where(hidden: false).sample
    end

    def some_schedule_for(user)
      # let's choose a schedule that is ot part of a joint accounts
      Schedule.where(account_id: users(user).accounts).where.not(account_id: joint_acounts).sample
    end

    def joint_acounts
      Relation.select(:account_id).group(:account_id).having("COUNT(account_id) > 1")
    end

    def random_account
      Account.where(id: Category.select(:account_id)).sample
    end

    def another(random_account)
      Account.where.not(id: random_account.id).sample
    end
  end
end
