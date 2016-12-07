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

ActiveRecord::Schema.define(version: 20161207045554) do

  create_table "comments", force: :cascade do |t|
    t.integer  "incident_id", limit: 4,     null: false
    t.integer  "user_id",     limit: 4,     null: false
    t.text     "comment",     limit: 65535, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "comments", ["incident_id"], name: "index_comments_on_incident_id", using: :btree

  create_table "escalation_series", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.text     "settings",   limit: 65535
  end

  create_table "escalations", force: :cascade do |t|
    t.integer  "escalate_to_id",       limit: 4
    t.integer  "escalate_after_sec",   limit: 4
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "escalation_series_id", limit: 4
  end

  add_index "escalations", ["escalate_to_id"], name: "index_escalations_on_escalate_to_id", using: :btree
  add_index "escalations", ["escalation_series_id"], name: "index_escalations_on_escalation_series_id", using: :btree

  create_table "incident_events", force: :cascade do |t|
    t.integer  "incident_id", limit: 4
    t.integer  "kind",        limit: 4
    t.text     "text",        limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.text     "info",        limit: 65535
  end

  add_index "incident_events", ["incident_id"], name: "index_incident_events_on_incident_id", using: :btree

  create_table "incidents", force: :cascade do |t|
    t.string   "subject",     limit: 255
    t.text     "description", limit: 65535
    t.integer  "topic_id",    limit: 4
    t.datetime "occured_at"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "status",      limit: 4
  end

  add_index "incidents", ["topic_id"], name: "index_incidents_on_topic_id", using: :btree

  create_table "maintenances", force: :cascade do |t|
    t.integer  "topic_id",   limit: 4
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "filter",     limit: 255
  end

  add_index "maintenances", ["topic_id"], name: "index_maintenances_on_topic_id", using: :btree

  create_table "notifier_providers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "kind",       limit: 4
    t.text     "settings",   limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "notifiers", force: :cascade do |t|
    t.text     "settings",         limit: 65535
    t.integer  "notify_after_sec", limit: 4
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "user_id",          limit: 4
    t.integer  "provider_id",      limit: 4
    t.integer  "topic_id",         limit: 4
    t.boolean  "enabled",                        default: true
  end

  add_index "notifiers", ["provider_id"], name: "index_notifiers_on_provider_id", using: :btree
  add_index "notifiers", ["topic_id"], name: "index_notifiers_on_topic_id", using: :btree
  add_index "notifiers", ["user_id"], name: "index_notifiers_on_user_id", using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.integer  "kind",                 limit: 4
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "escalation_series_id", limit: 4
    t.boolean  "enabled",                          default: true
  end

  add_index "topics", ["escalation_series_id"], name: "index_topics_on_escalation_series_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "email",       limit: 255
    t.string   "login_token", limit: 255
    t.boolean  "active",                    default: false
    t.string   "provider",    limit: 255
    t.string   "uid",         limit: 255
    t.text     "credentials", limit: 65535
  end

  add_foreign_key "escalations", "escalation_series"
  add_foreign_key "escalations", "users", column: "escalate_to_id"
  add_foreign_key "incident_events", "incidents"
  add_foreign_key "incidents", "topics"
  add_foreign_key "maintenances", "topics"
  add_foreign_key "notifiers", "notifier_providers", column: "provider_id"
  add_foreign_key "notifiers", "topics"
  add_foreign_key "notifiers", "users"
  add_foreign_key "topics", "escalation_series"
end
