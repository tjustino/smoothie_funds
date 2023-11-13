# frozen_string_literal: true

# Boolean columns should always have a default value and a NOT NULL constraint
class ChangeColumnDefaultToCategories < ActiveRecord::Migration[7.1]
  def change
    change_column_null :categories, :hidden, false
  end
end
