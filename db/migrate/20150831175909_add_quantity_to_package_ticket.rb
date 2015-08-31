class AddQuantityToPackageTicket < ActiveRecord::Migration
  def change
  	add_column :package_tickets, :quantity, :integer
  end
end
