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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101209194529) do

  create_table "accounts", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accounts", ["name"], :name => "index_accounts_on_name"
  add_index "accounts", ["user_id"], :name => "index_accounts_on_user_id"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  add_index "tags", ["account_id"], :name => "index_tags_on_account_id"
  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "tags_transactions", :id => false, :force => true do |t|
    t.integer "tag_id"
    t.integer "transaction_id"
  end

  add_index "tags_transactions", ["tag_id", "transaction_id"], :name => "index_tags_transactions_on_tag_id_and_transaction_id"
  add_index "tags_transactions", ["tag_id"], :name => "index_tags_transactions_on_tag_id"
  add_index "tags_transactions", ["transaction_id"], :name => "index_tags_transactions_on_transaction_id"

  create_table "transactions", :force => true do |t|
    t.datetime "transaction_date"
    t.string   "description"
    t.float    "amount"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["account_id"], :name => "index_transactions_on_account_id"
  add_index "transactions", ["transaction_date"], :name => "index_transactions_on_transaction_date"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
