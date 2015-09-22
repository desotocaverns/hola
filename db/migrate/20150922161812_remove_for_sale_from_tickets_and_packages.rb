class RemoveForSaleFromTicketsAndPackages < ActiveRecord::Migration
  def change
    remove_column :tickets, :for_sale
    remove_column :packages, :for_sale
  end
end
