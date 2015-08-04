class ChangeValueFromIntToDecimal < ActiveRecord::Migration
  def change
    change_column :purchases, :total_price, :decimal
    change_column :purchases, :tax, :decimal
    
    change_column :packages, :price, :decimal
  end
end
