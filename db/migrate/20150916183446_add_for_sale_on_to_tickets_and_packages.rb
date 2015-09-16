class AddForSaleOnToTicketsAndPackages < ActiveRecord::Migration
  def change
    add_column :tickets, :for_sale_on, :date
    add_column :packages, :for_sale_on, :date
  end
end
