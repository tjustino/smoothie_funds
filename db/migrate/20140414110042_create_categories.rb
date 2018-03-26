# frozen_string_literal: true

# Create Categories settings
class CreateCategories < ActiveRecord::Migration[4.2]
  def change
    create_table :categories do |t|
      t.belongs_to  :account,   null: false, index: true
      t.string      :name,      null: false
      t.integer     :created_by
      t.integer     :updated_by

      t.timestamps
    end

    add_index :categories, %i[account_id name], unique: true
  end
end
