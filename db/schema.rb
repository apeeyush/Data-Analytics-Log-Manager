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

ActiveRecord::Schema.define(version: 20140621125340) do

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

end
