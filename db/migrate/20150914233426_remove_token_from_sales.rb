class RemoveTokenFromSales < ActiveRecord::Migration
  def change
    remove_column :sales, :token
  end
end
