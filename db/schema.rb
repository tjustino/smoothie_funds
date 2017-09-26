# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151009111758) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.decimal "initial_balance", precision: 8, scale: 2, null: false
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "hidden", default: false
  end

  create_table "accounts_users", id: false, force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "user_id", null: false
    t.index ["account_id", "user_id"], name: "index_accounts_users_on_account_id_and_user_id", unique: true
    t.index ["account_id"], name: "index_accounts_users_on_account_id"
    t.index ["user_id"], name: "index_accounts_users_on_user_id"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "name", null: false
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id", "name"], name: "index_categories_on_account_id_and_name", unique: true
    t.index ["account_id"], name: "index_categories_on_account_id"
  end

  create_table "pending_users", id: :serial, force: :cascade do |t|
    t.integer "account_id", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_pending_users_on_account_id", unique: true
  end

  create_table "schedules", id: :serial, force: :cascade do |t|
    t.integer "account_id", null: false
    t.date "next_time", null: false
    t.integer "frequency", null: false
    t.string "period", null: false
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_schedules_on_account_id"
  end

  create_table "searches", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.text "accounts", null: false
    t.decimal "min", precision: 8, scale: 2
    t.decimal "max", precision: 8, scale: 2
    t.date "before"
    t.date "after"
    t.text "categories"
    t.integer "operator"
    t.string "comment"
    t.integer "checked"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_searches_on_user_id"
  end

  create_table "transactions", id: :serial, force: :cascade do |t|
    t.integer "account_id", null: false
    t.integer "category_id", null: false
    t.date "date", null: false
    t.decimal "amount", precision: 8, scale: 2, null: false
    t.boolean "checked"
    t.text "comment"
    t.integer "created_by"
    t.integer "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "schedule_id"
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["category_id"], name: "index_transactions_on_category_id"
    t.index ["schedule_id"], name: "index_transactions_on_schedule_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", null: false
    t.string "name"
    t.string "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
