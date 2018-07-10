# frozen_string_literal: true

# Rename accounts_users table to relations
class RenameAccountsUsers < ActiveRecord::Migration[5.2]
  def up
    rename_table :accounts_users, :relations
  end

  def down
    rename_table :relations, :accounts_users
  end
end
