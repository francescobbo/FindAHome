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

ActiveRecord::Schema.define(version: 2021_07_23_072215) do

  create_table "properties", force: :cascade do |t|
    t.string "source"
    t.text "url"
    t.string "agency"
    t.integer "sqm"
    t.integer "rpm"
    t.integer "bedrooms"
    t.integer "bathrooms"
    t.float "latitude"
    t.float "longitude"
    t.integer "ups", default: 0
    t.integer "downs", default: 0
    t.text "comment"
    t.text "description"
    t.boolean "garden"
    t.text "images"
    t.text "plan"
    t.date "available"
    t.string "prop_type"
    t.string "furnish"
    t.text "listing_history"
    t.text "stations"
    t.text "address"
    t.text "key_features"
    t.datetime "updated_at", precision: 6, null: false
    t.integer "section_id"
    t.datetime "hidden_at"
    t.boolean "star", default: false, null: false
    t.index ["section_id"], name: "index_properties_on_section_id"
    t.index ["url"], name: "index_properties_on_url", unique: true
  end

  create_table "sections", force: :cascade do |t|
    t.text "data"
    t.text "geojson"
    t.date "lastrun"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "consider", default: true, null: false
  end

end
