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

ActiveRecord::Schema.define(version: 20150127152127) do

  create_table "escalation_series", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "escalations", force: :cascade do |t|
    t.integer  "escalate_to_id"
    t.integer  "escalate_after_sec"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "escalation_series_id"
  end

  add_index "escalations", ["escalate_to_id"], name: "index_escalations_on_escalate_to_id"
  add_index "escalations", ["escalation_series_id"], name: "index_escalations_on_escalation_series_id"

  create_table "incident_events", force: :cascade do |t|
    t.integer  "incident_id"
    t.integer  "kind"
    t.text     "text"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.text     "info"
  end

  add_index "incident_events", ["incident_id"], name: "index_incident_events_on_incident_id"

  create_table "incidents", force: :cascade do |t|
    t.string   "subject"
    t.text     "description"
    t.integer  "topic_id"
    t.datetime "occured_at"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "status"
  end

  add_index "incidents", ["topic_id"], name: "index_incidents_on_topic_id"

  create_table "notifier_providers", force: :cascade do |t|
    t.string   "name"
    t.integer  "kind"
    t.text     "settings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifiers", force: :cascade do |t|
    t.text     "settings"
    t.integer  "notify_after_sec"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "user_id"
    t.integer  "provider_id"
  end

  add_index "notifiers", ["provider_id"], name: "index_notifiers_on_provider_id"
  add_index "notifiers", ["user_id"], name: "index_notifiers_on_user_id"

  create_table "topics", force: :cascade do |t|
    t.string   "name"
    t.integer  "kind"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "escalation_series_id"
  end

  add_index "topics", ["escalation_series_id"], name: "index_topics_on_escalation_series_id"

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
