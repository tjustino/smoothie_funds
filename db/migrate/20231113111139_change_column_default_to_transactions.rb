# Boolean columns should always have a default value and a NOT NULL constraint
class ChangeColumnDefaultToTransactions < ActiveRecord::Migration[7.1]
  def change
    change_column_default :transactions, :checked, from: nil, to: false
    change_column_null    :transactions, :checked, false
  end
end
