class RemoveQuantityFromPurchases < ActiveRecord::Migration
  def change
    remove_column :purchases, :quantity
  end
end
