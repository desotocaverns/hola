class AddRedeemedAtToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :redeemed_at, :date
  end
end
