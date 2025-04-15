class CreateSearches < ActiveRecord::Migration[4.2]
  def change
    create_table :searches do |t|
      t.belongs_to :user,     null: false, index: true
      t.text       :accounts, null: false
      t.decimal    :min,      precision: 8, scale: 2
      t.decimal    :max,      precision: 8, scale: 2
      t.date       :before
      t.date       :after
      t.text       :categories
      t.integer    :operator
      t.string     :comment
      t.integer    :checked

      t.timestamps null: false
    end
  end
end
