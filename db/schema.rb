# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_24_114008) do
  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "initial_balance", precision: 8, scale: 2, null: false
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "hidden", default: false, null: false
    t.index ["created_by"], name: "index_accounts_on_created_by"
    t.index ["updated_by"], name: "index_accounts_on_updated_by"
  end

  create_table "categories", force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "name", null: false
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "hidden", default: false, null: false
    t.index ["account_id", "name"], name: "index_categories_on_account_id_and_name", unique: true
    t.index ["account_id"], name: "index_categories_on_account_id"
    t.index ["created_by"], name: "index_categories_on_created_by"
    t.index ["updated_by"], name: "index_categories_on_updated_by"
  end

  create_table "pending_users", force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "email", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["account_id"], name: "index_pending_users_on_account_id", unique: true
  end

  create_table "relations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "account_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_relations_on_account_id"
    t.index ["user_id", "account_id"], name: "index_relations_on_user_id_and_account_id", unique: true
    t.index ["user_id"], name: "index_relations_on_user_id"
  end

  create_table "schedules", force: :cascade do |t|
    t.integer "account_id", null: false
    t.date "next_time", null: false
    t.integer "frequency", null: false
    t.string "period", null: false
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["account_id"], name: "index_schedules_on_account_id"
    t.index ["created_by"], name: "index_schedules_on_created_by"
    t.index ["updated_by"], name: "index_schedules_on_updated_by"
  end

  create_table "search_targets", force: :cascade do |t|
    t.integer "search_id", null: false
    t.string "target_type", null: false
    t.integer "target_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["search_id"], name: "index_search_targets_on_search_id"
    t.index ["target_type", "target_id"], name: "index_search_targets_on_target"
  end

  create_table "searches", force: :cascade do |t|
    t.integer "user_id", null: false
    t.decimal "min", precision: 8, scale: 2
    t.decimal "max", precision: 8, scale: 2
    t.date "before"
    t.date "after"
    t.integer "operator"
    t.string "comment"
    t.integer "checked"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "category_id", null: false
    t.date "date", null: false
    t.decimal "amount", precision: 8, scale: 2, null: false
    t.boolean "checked", default: false, null: false
    t.text "comment"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "schedule_id"
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["category_id"], name: "index_transactions_on_category_id"
    t.index ["created_by"], name: "index_transactions_on_created_by"
    t.index ["schedule_id"], name: "index_transactions_on_schedule_id"
    t.index ["updated_by"], name: "index_transactions_on_updated_by"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name"
    t.string "password_digest"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "accounts", "users", column: "created_by"
  add_foreign_key "accounts", "users", column: "updated_by"
  add_foreign_key "categories", "accounts"
  add_foreign_key "categories", "users", column: "created_by"
  add_foreign_key "categories", "users", column: "updated_by"
  add_foreign_key "pending_users", "accounts"
  add_foreign_key "relations", "accounts"
  add_foreign_key "relations", "users"
  add_foreign_key "schedules", "accounts"
  add_foreign_key "schedules", "users", column: "created_by"
  add_foreign_key "schedules", "users", column: "updated_by"
  add_foreign_key "search_targets", "searches", on_delete: :cascade
  add_foreign_key "searches", "users"
  add_foreign_key "transactions", "accounts"
  add_foreign_key "transactions", "categories"
  add_foreign_key "transactions", "schedules"
  add_foreign_key "transactions", "users", column: "created_by"
  add_foreign_key "transactions", "users", column: "updated_by"
end
