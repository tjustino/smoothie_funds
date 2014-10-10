class AddHiddenToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :hidden, :boolean, default: false
  end
end
