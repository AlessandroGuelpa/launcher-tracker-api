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

ActiveRecord::Schema[8.1].define(version: 2026_06_09_204823) do
  create_table "launches", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "date_utc"
    t.text "details"
    t.string "external_id"
    t.bigint "launchpad_id", null: false
    t.string "name"
    t.string "provider_name"
    t.json "raw_data"
    t.bigint "rocket_id", null: false
    t.boolean "success"
    t.datetime "updated_at", null: false
    t.index ["launchpad_id"], name: "index_launches_on_launchpad_id"
    t.index ["provider_name"], name: "index_launches_on_provider_name"
    t.index ["rocket_id"], name: "index_launches_on_rocket_id"
  end

  create_table "launchpads", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "external_id"
    t.string "full_name"
    t.float "latitude"
    t.string "locality"
    t.float "longitude"
    t.string "name"
    t.string "region"
    t.datetime "updated_at", null: false
  end

  create_table "rockets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.boolean "active"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "external_id"
    t.date "first_flight"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "launches", "launchpads"
  add_foreign_key "launches", "rockets"
end
