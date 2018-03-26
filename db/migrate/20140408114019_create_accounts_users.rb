# frozen_string_literal: true

# One user can create multiple accounts
# One account can belong to multiple users
class CreateAccountsUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :accounts_users, id: false do |t|
      t.belongs_to :account, null: false, index: true
      t.belongs_to :user,    null: false, index: true

      t.timestamps
    end

    add_index :accounts_users, %i[account_id user_id], unique: true
  end
end
