class AddScheduleIdToTransactions < ActiveRecord::Migration
  def change
    add_column  :transactions, :schedule_id, :integer
    add_index   :transactions, :schedule_id
  end
end
