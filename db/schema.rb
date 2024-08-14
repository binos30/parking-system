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

ActiveRecord::Schema[7.2].define(version: 2024_08_14_052741) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "parking_slot_id", null: false
    t.integer "vehicle_type", null: false
    t.string "plate_number", null: false
    t.datetime "date_park"
    t.datetime "date_unpark"
    t.decimal "fee", precision: 8, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parking_slot_id"], name: "index_bookings_on_parking_slot_id"
    t.index ["plate_number"], name: "index_bookings_on_plate_number"
    t.index ["vehicle_type"], name: "index_bookings_on_vehicle_type"
  end

  create_table "entrances", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_entrances_on_name", unique: true
  end

  create_table "parking_lots", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_parking_lots_on_name", unique: true
  end

  create_table "parking_slots", force: :cascade do |t|
    t.integer "slot_type", null: false
    t.string "distances", null: false
    t.bigint "parking_lot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status"
    t.index ["distances"], name: "index_parking_slots_on_distances"
    t.index ["parking_lot_id"], name: "index_parking_slots_on_parking_lot_id"
    t.index ["slot_type"], name: "index_parking_slots_on_slot_type"
    t.index ["status"], name: "index_parking_slots_on_status"
  end

  add_foreign_key "bookings", "parking_slots"
  add_foreign_key "parking_slots", "parking_lots"
end
