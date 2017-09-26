class CreateTransactions < ActiveRecord::Migration[4.2]
  def change
    create_table :transactions do |t|
      t.belongs_to  :account,  null: false, index: true
      t.belongs_to  :category, null: false, index: true
      t.date        :date,     null: false
      t.decimal     :amount,   null: false, precision: 8, scale: 2
      t.boolean     :checked
      t.text        :comment
      t.integer     :created_by
      t.integer     :updated_by

      t.timestamps
    end
  end
end
