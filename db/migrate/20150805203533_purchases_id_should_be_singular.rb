class PurchasesIdShouldBeSingular < ActiveRecord::Migration
  def change
    rename_column :purchased_packages, :purchases_id, :purchase_id
  end
end
