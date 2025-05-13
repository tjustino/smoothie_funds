class CreateSearchTargets < ActiveRecord::Migration[8.0]
  def up
    create_table :search_targets do |t|
      t.references :search, null: false, foreign_key: { on_delete: :cascade }
      t.references :target, polymorphic: true, null: false, index: true

      t.timestamps null: true
    end

    # data migration
    say_with_time "Migration of accounts and categories columns to the SearchTargets polymorphic table" do
      Search.reset_column_information

      Search.find_each do |search|
        # ⚠️ the search[:column] syntax is deliberate, natural association would be problematic due to new associations
        accounts   = Account.where(id: YAML.load(search[:accounts]))
        accounts.each { |account| SearchTarget.create! search: search, target: account }

        categories = Category.where(id: YAML.load(search[:categories]), account_id: accounts.ids)
        categories.each { |category| SearchTarget.create! search: search, target: category }
      end
    end

    # remove unused columns
    remove_column :searches, :accounts   if column_exists?(:searches, :accounts)
    remove_column :searches, :categories if column_exists?(:searches, :categories)
  end

  def down
    add_column :searches, :accounts, :text
    add_column :searches, :categories, :text

    # data rollback
    say_with_time "Migration of polymorphic table to the old accounts and categories columns" do
      SearchTarget.reset_column_information

      SearchTarget.select(:search_id).distinct.each do |search_target|
        search = Search.find(search_target.search_id)
        accounts = SearchTarget.where(search_id: search, target_type: "Account").pluck(:target_id).to_yaml
        categories = SearchTarget.where(search_id: search, target_type: "Category").pluck(:target_id).to_yaml
        Search.where(id: search).update_all(accounts: accounts, categories: categories)
      end
    end

    # drop target table
    drop_table :search_targets
  end
end
