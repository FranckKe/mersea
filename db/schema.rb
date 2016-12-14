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

ActiveRecord::Schema.define(version: 20161214214800) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"
  enable_extension "citext"

  create_table "admins", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name"
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admins_on_email", using: :btree
  end

  create_table "reports", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "tracer_id"
    t.string   "name"
    t.string   "email"
    t.integer  "quantity"
    t.string   "address"
    t.float    "longitude"
    t.float    "latitude"
    t.text     "description"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.date     "reported_at"
    t.string   "status"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["address"], name: "index_reports_on_address", using: :btree
    t.index ["latitude"], name: "index_reports_on_latitude", using: :btree
    t.index ["longitude"], name: "index_reports_on_longitude", using: :btree
    t.index ["reported_at"], name: "index_reports_on_reported_at", using: :btree
    t.index ["status"], name: "index_reports_on_status", using: :btree
    t.index ["tracer_id"], name: "index_reports_on_tracer_id", using: :btree
  end

  create_table "tracers", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "origin"
    t.string   "kind"
    t.float    "longitude"
    t.float    "latitude"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "icon_url_file_name"
    t.string   "icon_url_content_type"
    t.integer  "icon_url_file_size"
    t.datetime "icon_url_updated_at"
  end

end
