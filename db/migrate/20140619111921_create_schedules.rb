class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.belongs_to  :account,     null: false, index: true
      t.belongs_to  :transaction, null: false, index: true
      t.date        :next_time,   null: false
      t.integer     :frequency,   null: false
      t.string      :period,      null: false
      t.integer     :created_by
      t.integer     :updated_by

      t.timestamps
    end
  end
end
