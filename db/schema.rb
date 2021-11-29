# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_11_29_015329) do

  create_table "door_messages", charset: "utf8mb4", force: :cascade do |t|
    t.string "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "room_id", null: false
    t.index ["room_id"], name: "index_door_messages_on_room_id"
  end

  create_table "lights", charset: "utf8mb4", force: :cascade do |t|
    t.string "entity_id"
    t.string "name"
    t.bigint "room_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["room_id"], name: "index_lights_on_room_id"
  end

  create_table "rooms", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "door_contact_id"
    t.string "speaker_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "cooldown_seconds", default: 5
    t.datetime "cooldown_started"
    t.string "quiet_hours"
    t.string "say_services", limit: 4000
  end

  add_foreign_key "lights", "rooms"
end
