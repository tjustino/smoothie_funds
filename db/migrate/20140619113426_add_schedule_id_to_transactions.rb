# frozen_string_literal: true

# One part of each Schedules are Transactions
class AddScheduleIdToTransactions < ActiveRecord::Migration[4.2]
  def change
    add_column  :transactions, :schedule_id, :integer
    add_index   :transactions, :schedule_id
  end
end
