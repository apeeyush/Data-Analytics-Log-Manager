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

ActiveRecord::Schema.define(version: 20140703081856) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "documents", force: true do |t|
    t.string   "name"
    t.json     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logs", force: true do |t|
    t.string   "session"
    t.string   "username"
    t.string   "application"
    t.string   "activity"
    t.string   "event"
    t.datetime "time"
    t.hstore   "parameters"
    t.hstore   "extras"
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
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
