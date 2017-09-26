class CreatePendingUsers < ActiveRecord::Migration[4.2]
  def change
    create_table :pending_users do |t|
      t.belongs_to  :account, null: false
      t.string      :email,   null: false

      t.timestamps null: false
    end

    add_index :pending_users, :account_id, unique: true
  end
end
