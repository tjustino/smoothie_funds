# Name must be optional
class ChangeNameNullToUsers < ActiveRecord::Migration[4.2]
  def change
    change_column_null :users, :name, true
  end
end
