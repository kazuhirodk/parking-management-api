# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_11_15_104803) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "parking_tickets", force: :cascade do |t|
    t.date "entrance_date"
    t.date "exit_date"
    t.bigint "vehicle_id"
    t.bigint "payment_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["payment_id"], name: "index_parking_tickets_on_payment_id"
    t.index ["vehicle_id"], name: "index_parking_tickets_on_vehicle_id"
  end

  create_table "payments", force: :cascade do |t|
    t.date "payment_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "parking_ticket_id"
    t.index ["parking_ticket_id"], name: "index_payments_on_parking_ticket_id"
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "plate"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "parking_tickets", "payments"
  add_foreign_key "parking_tickets", "vehicles"
  add_foreign_key "payments", "parking_tickets"
end
