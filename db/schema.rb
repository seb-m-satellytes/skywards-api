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

ActiveRecord::Schema[7.1].define(version: 2024_02_01_154256) do
  create_table "activities", force: :cascade do |t|
    t.string "activity_type"
    t.integer "start_time", default: 0
    t.integer "end_time", default: 0
    t.integer "character_id"
    t.integer "settlement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "is_evaluated"
  end

  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.integer "health_status"
    t.integer "skill_level"
    t.string "current_activity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "settlement_id", null: false
    t.integer "morale_status"
    t.string "specialization"
    t.index ["settlement_id"], name: "index_characters_on_settlement_id"
  end

  create_table "game_sessions", force: :cascade do |t|
    t.datetime "start_time"
    t.integer "in_game_minutes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resources", force: :cascade do |t|
    t.string "resource_type"
    t.integer "amount", default: 0
    t.string "resourceable_type"
    t.integer "resourceable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settlements", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.integer "level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "game_session_id"
    t.index ["game_session_id"], name: "index_settlements_on_game_session_id"
  end

  create_table "status_effects", force: :cascade do |t|
    t.string "name"
    t.integer "start_time"
    t.integer "end_time"
    t.integer "character_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_status_effects_on_character_id"
  end

  add_foreign_key "characters", "settlements"
  add_foreign_key "settlements", "game_sessions"
  add_foreign_key "status_effects", "characters"
end
