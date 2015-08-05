class RemovePurchaseIdFromPurchasedPackages < ActiveRecord::Migration
  def change
    remove_column :purchased_packages, :purchase_id
  end
end
