class ChangeTotalPriceToChargeTotal < ActiveRecord::Migration
  def change
    rename_column :sales, :total_price, :charge_total
  end
end
