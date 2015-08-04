class CreatePurchasedPackages < ActiveRecord::Migration
  def change
    create_table :purchased_packages do |t|
      t.integer :purchase_id
      t.integer :quantity
      t.integer :package_id

      t.timestamps null: false
    end
  end
end
