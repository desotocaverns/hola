class PennyValuesForPrices < ActiveRecord::Migration
  def change
    change_column :purchases, :total_price, :integer
    change_column :purchases, :tax, :integer

    change_column :packages, :price, :integer
  end
end
