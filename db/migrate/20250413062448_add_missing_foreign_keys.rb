class AddMissingForeignKeys < ActiveRecord::Migration[8.0]
  def change
    # to accounts
    add_index       :accounts, :created_by
    add_index       :accounts, :updated_by
    add_foreign_key :accounts, :users, column: :created_by
    add_foreign_key :accounts, :users, column: :updated_by

    # to categories
    add_foreign_key :categories, :accounts
    add_index       :categories, :created_by
    add_index       :categories, :updated_by
    add_foreign_key :categories, :users, column: :created_by
    add_foreign_key :categories, :users, column: :updated_by

    # to pending users
    add_foreign_key :pending_users, :accounts

    # to relations
    add_foreign_key :relations, :accounts
    add_foreign_key :relations, :users

    # to schedules
    add_foreign_key :schedules, :accounts
    add_index       :schedules, :created_by
    add_index       :schedules, :updated_by
    add_foreign_key :schedules, :users, column: :created_by
    add_foreign_key :schedules, :users, column: :updated_by

    # to searches
    add_foreign_key :searches, :users

    # to transactions
    add_foreign_key :transactions, :accounts
    add_foreign_key :transactions, :categories
    add_foreign_key :transactions, :schedules
    add_index       :transactions, :created_by
    add_index       :transactions, :updated_by
    add_foreign_key :transactions, :users, column: :created_by
    add_foreign_key :transactions, :users, column: :updated_by
  end
end
