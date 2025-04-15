class RemoveTimestampsNotNull < ActiveRecord::Migration[8.0]
  def change
    # to pending users
    change_column_null :pending_users, :created_at, true
    change_column_null :pending_users, :updated_at, true

    # to searches
    change_column_null :searches, :created_at, true
    change_column_null :searches, :updated_at, true
  end
end
