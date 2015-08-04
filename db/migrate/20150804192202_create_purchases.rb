class CreatePurchases < ActiveRecord::Migration
  def change
    create_table :purchases do |t|
      t.string :name, limit: 40
      t.integer :tax
      t.integer :total_price

      t.timestamps null: false
    end
  end
end
