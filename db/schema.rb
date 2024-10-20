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

ActiveRecord::Schema[7.1].define(version: 2024_10_20_112556) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "markers", force: :cascade do |t|
    t.string "name"
    t.text "content"
    t.text "enigma"
    t.boolean "found"
    t.float "radius"
    t.float "latitude"
    t.float "longitude"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "marker_pass"
  end

  create_table "team_markers", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "marker_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "order"
    t.boolean "visited"
    t.float "circle_center_latitude"
    t.float "circle_center_longitude"
    t.string "access_token"
    t.index ["marker_id"], name: "index_team_markers_on_marker_id"
    t.index ["team_id"], name: "index_team_markers_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "captain_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "team_id"
    t.boolean "leader"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "team_markers", "markers"
  add_foreign_key "team_markers", "teams"
  add_foreign_key "teams", "users", column: "captain_id"
end
