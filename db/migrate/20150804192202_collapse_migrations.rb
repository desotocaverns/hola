class CreatePurchases < ActiveRecord::Migration
  def change
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
      t.boolean  "activated",              default: false
      t.string   "invitation_token"
      t.datetime "invitation_created_at"
      t.datetime "invitation_sent_at"
      t.datetime "invitation_accepted_at"
      t.integer  "invitation_limit"
      t.integer  "invited_by_id"
      t.string   "invited_by_type"
      t.integer  "invitations_count",      default: 0
    end

    add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
    add_index "admins", ["invitation_token"], name: "index_admins_on_invitation_token", unique: true, using: :btree
    add_index "admins", ["invitations_count"], name: "index_admins_on_invitations_count", using: :btree
    add_index "admins", ["invited_by_id"], name: "index_admins_on_invited_by_id", using: :btree
    add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

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
      t.string   "name",               limit: 40
      t.integer  "tax"
      t.integer  "total_price"
      t.datetime "created_at",                    null: false
      t.datetime "updated_at",                    null: false
      t.string   "charge_id"
      t.string   "email"
      t.string   "redemption_id"
      t.date     "redeemed_on"
      t.date     "expires_on"
      t.string   "masked_cc_number"
      t.string   "masked_cvc"
      t.string   "cc_expiration_date"
      t.string   "stripe_token"
    end
  end
end