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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120120200853) do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "apt"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.string   "scope"
    t.string   "short_name"
    t.string   "long_description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions_roles", :id => false, :force => true do |t|
    t.integer  "permission_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "file_path"
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "duration"
    t.integer  "sprint_duration"
    t.text     "goal"
    t.text     "value"
    t.text     "roi"
    t.string   "client"
  end

  create_table "role_memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "primary"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sprints", :force => true do |t|
    t.integer  "number"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sprints", ["project_id"], :name => "index_sprints_on_project_id"

  create_table "status_transitions", :force => true do |t|
    t.integer  "sub_item_id"
    t.integer  "user_id"
    t.string   "from_status"
    t.string   "to_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "status_transitions", ["sub_item_id"], :name => "index_status_transitions_on_sub_item_id"
  add_index "status_transitions", ["user_id"], :name => "index_status_transitions_on_user_id"

  create_table "stories", :force => true do |t|
    t.string   "description"
    t.integer  "number"
    t.integer  "owner_id"
    t.integer  "project_id"
    t.integer  "sprint_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sub_items", :force => true do |t|
    t.string   "description"
    t.integer  "number"
    t.string   "item_type"
    t.string   "status"
    t.integer  "owner_id"
    t.integer  "story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "estimated_time", :default => 0.0
  end

  add_index "sub_items", ["story_id"], :name => "index_sub_items_on_story_id"

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
    t.string   "guid"
    t.integer  "company_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "title"
    t.string   "phone"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
