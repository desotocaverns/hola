class AddExpirationColumnToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :expires_on, :date
    rename_column :purchases, :redeemed_at, :redeemed_on
  end
end
