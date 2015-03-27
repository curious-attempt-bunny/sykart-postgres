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

ActiveRecord::Schema.define(version: 20150326035033) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "racer_races", force: true do |t|
    t.integer  "racer_id"
    t.integer  "race_id"
    t.datetime "race_start"
    t.string   "nickname",     limit: 40
    t.decimal  "best_time",               precision: 6,  scale: 3
    t.integer  "kart_number"
    t.string   "kart_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "average_time",            precision: 10, scale: 3
  end

  add_index "racer_races", ["race_id"], name: "index_racer_races_on_race_id", using: :btree
  add_index "racer_races", ["racer_id", "best_time", "kart_type"], name: "index_racer_races_on_racer_id_and_best_time_and_kart_type", using: :btree
  add_index "racer_races", ["racer_id", "race_id"], name: "index_racer_races_on_racer_id_and_race_id", unique: true, using: :btree

end
