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

ActiveRecord::Schema.define(version: 2019_05_04_150058) do

  create_table "assets", force: :cascade do |t|
    t.integer "portfolio_id"
    t.string "address"
    t.integer "zipcode"
    t.string "city"
    t.boolean "is_restricted"
    t.integer "yoc"
    t.string "asset_ref"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["portfolio_id"], name: "index_assets_on_portfolio_id"
  end

  create_table "portfolios", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "units", force: :cascade do |t|
    t.string "asset_id"
    t.integer "size"
    t.boolean "is_rented"
    t.integer "rent"
    t.integer "unit_type"
    t.string "tenant"
    t.datetime "lease_start"
    t.datetime "lease_end"
    t.string "unit_ref"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_id"], name: "index_units_on_asset_id"
  end

end
