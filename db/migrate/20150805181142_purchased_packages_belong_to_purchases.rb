class PurchasedPackagesBelongToPurchases < ActiveRecord::Migration
  def change
    add_reference :purchased_packages, :purchases, index: true, foreign_key: true
  end
end
