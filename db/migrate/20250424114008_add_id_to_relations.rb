class AddIdToRelations < ActiveRecord::Migration[8.0]
  def up
    create_table :relations_new do |t|
      t.references :user,    null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true

      t.timestamps null: true
    end

    execute <<-SQL.squish
      INSERT INTO relations_new (user_id, account_id, created_at, updated_at)
      SELECT user_id, account_id, created_at, updated_at
      FROM relations;
    SQL

    drop_table   :relations
    rename_table :relations_new, :relations
    add_index    :relations, %i[user_id account_id], unique: true
  end

  def down
    # Recréer sans id
    create_table :relations_old, id: false do |t|
      t.references :user,    null: false, foreign_key: true
      t.references :account, null: false, foreign_key: true

      t.timestamps null: true
    end

    execute <<-SQL.squish
      INSERT INTO relations_old (user_id, account_id, created_at, updated_at)
      SELECT user_id, account_id, created_at, updated_at
      FROM relations;
    SQL

    drop_table   :relations
    rename_table :relations_old, :relations
    add_index    :relations, %i[user_id account_id], unique: true
  end
end
