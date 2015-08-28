class CollapseMigrations < ActiveRecord::Migration
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

    create_table :packages do |t|
      t.string :name
      t.integer :price
      t.boolean :for_sale, default: true
      t.text :description
      t.integer :version, null: false, default: 0
      t.timestamps null: false
    end

    create_table :package_tickets do |t|
      t.integer :package_id, null: false
      t.integer :ticket_id, null: false
      t.integer :ticket_version, null: false

      t.timestamps null: false
    end

    create_table :purchases do |t|
      t.string :type
      t.integer :sale_id
      t.date :redeemed_on
      t.string :redemption_code
      t.date :expires_on
      t.integer :package_id
      t.integer :package_revision_id
      t.integer :ticket_id
      t.integer :ticket_revision_id

      t.timestamps null: false
    end

    create_table :sales do |t|
      t.string :name
      t.string :email
      t.integer :tax
      t.integer :total_price
      t.string :charge_id

      t.timestamps null: false
    end

    create_table :tickets do |t|
      t.string :name, null: false
      t.integer :price, null: false
      t.boolean :for_sale, default: true
      t.text :description
      t.integer :version, null: false, default: 0

      t.timestamps null: false
    end

    create_table :ticket_revisions do |t|
      t.integer :version, null: false
      t.integer :ticket_id, null: false
      t.jsonb :ticket_data, null: false

      t.timestamps null: false
    end

    create_table :package_revisions do |t|
      t.integer :version, null: false
      t.integer :package_id, null: false
      t.jsonb :package_data, null: false

      t.timestamps null: false
    end

  end
end
