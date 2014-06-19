class AddScheduledToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :scheduled, :boolean
  end
end
