class CreatePackages < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :title, limit: 100
      t.text :description
      t.integer :price
      t.integer :cavern_tours
      t.integer :attractions

      t.timestamps null: false
    end
  end
end
