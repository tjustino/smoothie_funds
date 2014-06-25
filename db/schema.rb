# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140619113426) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: true do |t|
    t.string   "name",                                    null: false
    t.decimal  "initial_balance", precision: 8, scale: 2, null: false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accounts_users", id: false, force: true do |t|
    t.integer "account_id", null: false
    t.integer "user_id",    null: false
  end

  add_index "accounts_users", ["account_id", "user_id"], name: "index_accounts_users_on_account_id_and_user_id", unique: true, using: :btree
  add_index "accounts_users", ["account_id"], name: "index_accounts_users_on_account_id", using: :btree
  add_index "accounts_users", ["user_id"], name: "index_accounts_users_on_user_id", using: :btree

  create_table "categories", force: true do |t|
    t.integer  "account_id", null: false
    t.string   "name",       null: false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["account_id", "name"], name: "index_categories_on_account_id_and_name", unique: true, using: :btree
  add_index "categories", ["account_id"], name: "index_categories_on_account_id", using: :btree

  create_table "schedules", force: true do |t|
    t.integer  "account_id", null: false
    t.date     "next_time",  null: false
    t.integer  "frequency",  null: false
    t.string   "period",     null: false
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schedules", ["account_id"], name: "index_schedules_on_account_id", using: :btree

  create_table "transactions", force: true do |t|
    t.integer  "account_id",                          null: false
    t.integer  "category_id",                         null: false
    t.date     "date",                                null: false
    t.decimal  "amount",      precision: 8, scale: 2, null: false
    t.boolean  "checked"
    t.text     "comment"
    t.integer  "created_by"
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "schedule_id"
  end

  add_index "transactions", ["account_id"], name: "index_transactions_on_account_id", using: :btree
  add_index "transactions", ["category_id"], name: "index_transactions_on_category_id", using: :btree
  add_index "transactions", ["schedule_id"], name: "index_transactions_on_schedule_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",           null: false
    t.string   "name",            null: false
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
