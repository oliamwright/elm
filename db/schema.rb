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

ActiveRecord::Schema.define(:version => 20120315024142) do

  create_table "additional_time_items", :force => true do |t|
    t.integer  "project_id"
    t.integer  "user_id"
    t.float    "time",       :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sprint_id"
  end

  add_index "additional_time_items", ["project_id"], :name => "index_additional_time_items_on_project_id"
  add_index "additional_time_items", ["sprint_id"], :name => "index_additional_time_items_on_sprint_id"
  add_index "additional_time_items", ["user_id"], :name => "index_additional_time_items_on_user_id"

  create_table "answers", :force => true do |t|
    t.integer  "question_id"
    t.integer  "user_id"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"
  add_index "answers", ["user_id"], :name => "index_answers_on_user_id"

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

  create_table "log_events", :force => true do |t|
    t.string   "type"
    t.integer  "story_id"
    t.integer  "sub_item_id"
    t.text     "yaml_data"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  add_index "log_events", ["project_id"], :name => "index_log_events_on_project_id"
  add_index "log_events", ["story_id"], :name => "index_log_events_on_story_id"
  add_index "log_events", ["sub_item_id"], :name => "index_log_events_on_sub_item_id"
  add_index "log_events", ["user_id"], :name => "index_log_events_on_user_id"

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

  add_index "permissions_roles", ["permission_id"], :name => "index_permissions_roles_on_permission_id"
  add_index "permissions_roles", ["role_id"], :name => "index_permissions_roles_on_role_id"

  create_table "phases", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "project_id"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phases", ["project_id"], :name => "index_phases_on_project_id"

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
    t.string   "test_output_url"
    t.integer  "client_id"
  end

  add_index "projects", ["client_id"], :name => "index_projects_on_client_id"
  add_index "projects", ["owner_id"], :name => "index_projects_on_owner_id"

  create_table "questions", :force => true do |t|
    t.string   "questionable_type"
    t.integer  "questionable_id"
    t.integer  "user_id"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["questionable_type", "questionable_id"], :name => "index_questions_on_questionable_type_and_questionable_id"
  add_index "questions", ["user_id"], :name => "index_questions_on_user_id"

  create_table "role_memberships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "primary"
  end

  add_index "role_memberships", ["project_id"], :name => "index_role_memberships_on_project_id"
  add_index "role_memberships", ["role_id"], :name => "index_role_memberships_on_role_id"
  add_index "role_memberships", ["user_id"], :name => "index_role_memberships_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "internal_name"
  end

  create_table "sprints", :force => true do |t|
    t.integer  "number"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "phase_id"
  end

  add_index "sprints", ["phase_id"], :name => "index_sprints_on_phase_id"
  add_index "sprints", ["project_id"], :name => "index_sprints_on_project_id"

  create_table "stories", :force => true do |t|
    t.string   "description"
    t.integer  "number"
    t.integer  "owner_id"
    t.integer  "project_id"
    t.integer  "sprint_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approved"
    t.integer  "client_value", :default => 3
  end

  add_index "stories", ["owner_id"], :name => "index_stories_on_owner_id"
  add_index "stories", ["project_id"], :name => "index_stories_on_project_id"
  add_index "stories", ["sprint_id"], :name => "index_stories_on_sprint_id"

  create_table "sub_items", :force => true do |t|
    t.text     "description"
    t.integer  "number"
    t.string   "item_type"
    t.string   "status"
    t.integer  "owner_id"
    t.integer  "story_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "estimated_time", :default => 0.0
  end

  add_index "sub_items", ["owner_id"], :name => "index_sub_items_on_owner_id"
  add_index "sub_items", ["story_id"], :name => "index_sub_items_on_story_id"

  create_table "task_ownerships", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sub_item_id"
    t.float    "actual_time", :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "task_ownerships", ["sub_item_id"], :name => "index_task_ownerships_on_sub_item_id"
  add_index "task_ownerships", ["user_id"], :name => "index_task_ownerships_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
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
