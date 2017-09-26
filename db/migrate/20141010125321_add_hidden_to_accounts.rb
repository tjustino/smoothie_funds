class AddHiddenToAccounts < ActiveRecord::Migration[4.2]
  def change
    add_column :accounts, :hidden, :boolean, default: false
  end
end
