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

ActiveRecord::Schema.define(version: 20150807165107) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "packages", force: :cascade do |t|
    t.string   "title",        limit: 100
    t.text     "description"
    t.integer  "price"
    t.integer  "cavern_tours"
    t.integer  "attractions"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "for_sale",                 default: true
  end

  create_table "purchased_packages", force: :cascade do |t|
    t.integer  "quantity"
    t.integer  "package_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "purchase_id"
  end

  add_index "purchased_packages", ["purchase_id"], name: "index_purchased_packages_on_purchase_id", using: :btree

  create_table "purchases", force: :cascade do |t|
    t.string   "name",        limit: 40
    t.integer  "tax"
    t.integer  "total_price"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "charge_id"
    t.string   "email"
  end

end
