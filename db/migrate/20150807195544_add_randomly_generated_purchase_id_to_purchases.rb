class AddRandomlyGeneratedPurchaseIdToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :redemption_id, :integer
  end
end
