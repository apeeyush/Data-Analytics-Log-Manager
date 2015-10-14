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

ActiveRecord::Schema.define(version: 20151014141155) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "applications", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "applications_users", id: false, force: true do |t|
    t.integer "user_id",        null: false
    t.integer "application_id", null: false
  end

  create_table "data_queries", force: true do |t|
    t.json     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "data_queries", ["user_id"], name: "index_data_queries_on_user_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "delayed_reference_id"
    t.string   "delayed_reference_type"
  end

  add_index "delayed_jobs", ["delayed_reference_id"], name: "delayed_jobs_delayed_reference_id", using: :btree
  add_index "delayed_jobs", ["delayed_reference_type"], name: "delayed_jobs_delayed_reference_type", using: :btree
  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "documents", force: true do |t|
    t.string   "name"
    t.json     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_spreadsheets", force: true do |t|
    t.integer  "user_id"
    t.string   "status"
    t.string   "status_msg"
    t.text     "query"
    t.text     "file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "all_columns", default: false, null: false
  end

  create_table "logs", force: true do |t|
    t.string   "session"
    t.string   "username"
    t.string   "application"
    t.string   "activity"
    t.string   "event"
    t.datetime "time"
    t.hstore   "parameters",  default: {}, null: false
    t.hstore   "extras",      default: {}, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "event_value"
  end

  add_index "logs", ["activity"], name: "index_logs_on_activity", using: :btree
  add_index "logs", ["application"], name: "index_logs_on_application", using: :btree
  add_index "logs", ["event"], name: "index_logs_on_event", using: :btree
  add_index "logs", ["session"], name: "index_logs_on_session", using: :btree
  add_index "logs", ["time"], name: "index_logs_on_time", using: :btree
  add_index "logs", ["username"], name: "index_logs_on_username", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
