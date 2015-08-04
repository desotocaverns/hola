class AddForsaleRowToPackagesTable < ActiveRecord::Migration
  def change
    add_column :packages, :for_sale, :boolean, default: true
  end
end
