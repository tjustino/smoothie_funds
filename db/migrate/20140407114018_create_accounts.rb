class CreateAccounts < ActiveRecord::Migration[4.2]
  def change
    create_table :accounts do |t|
      t.string  :name,            null: false
      t.decimal :initial_balance, null: false, precision: 8, scale: 2
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
