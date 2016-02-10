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

ActiveRecord::Schema.define(version: 20160208231419) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "recoverable"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.boolean  "autocratic",             default: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["invitation_token"], name: "index_admins_on_invitation_token", unique: true, using: :btree
  add_index "admins", ["invitations_count"], name: "index_admins_on_invitations_count", using: :btree
  add_index "admins", ["invited_by_id"], name: "index_admins_on_invited_by_id", using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "package_revisions", force: :cascade do |t|
    t.integer  "version",      null: false
    t.integer  "package_id",   null: false
    t.jsonb    "package_data", null: false
    t.datetime "created_at",   null: false
  end

  create_table "package_tickets", force: :cascade do |t|
    t.integer "package_id",                 null: false
    t.integer "ticket_id",                  null: false
    t.integer "ticket_version",             null: false
    t.integer "quantity",       default: 1
  end

  add_index "package_tickets", ["package_id", "ticket_id"], name: "index_package_tickets_on_package_id_and_ticket_id", unique: true, using: :btree

  create_table "packages", force: :cascade do |t|
    t.string  "name",                    null: false
    t.integer "price",       default: 0, null: false
    t.text    "description"
    t.integer "version",     default: 0, null: false
    t.integer "priority"
    t.date    "for_sale_on"
  end

  create_table "purchases", force: :cascade do |t|
    t.string  "type",                            null: false
    t.integer "sale_id",                         null: false
    t.date    "expires_on",                      null: false
    t.integer "package_revision_id"
    t.integer "ticket_revision_id"
    t.string  "token",                           null: false
    t.integer "quantity",            default: 1, null: false
  end

  create_table "sales", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "tax",             default: 0, null: false
    t.integer  "charge_total",    default: 0, null: false
    t.string   "charge_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "redemption_code"
    t.date     "claimed_on"
    t.boolean  "mailing_list"
  end

  create_table "settings", primary_key: "settings", force: :cascade do |t|
    t.float  "tax",                    default: 0.07
    t.string "company_email",          default: "store@desotocaverns.com"
    t.text   "sale_notification_list"
  end

  create_table "ticket_revisions", force: :cascade do |t|
    t.integer  "version",     null: false
    t.integer  "ticket_id",   null: false
    t.jsonb    "ticket_data", null: false
    t.datetime "created_at",  null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.string  "name",                    null: false
    t.integer "price",       default: 0, null: false
    t.text    "description"
    t.integer "version",     default: 0, null: false
    t.integer "priority"
    t.date    "for_sale_on"
  end

end
