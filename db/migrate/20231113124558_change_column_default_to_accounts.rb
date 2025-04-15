# Boolean columns should always have a default value and a NOT NULL constraint
class ChangeColumnDefaultToAccounts < ActiveRecord::Migration[7.1]
  def change
    change_column_null :accounts, :hidden, false
  end
end
