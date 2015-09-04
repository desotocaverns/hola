class AddTokenToSale < ActiveRecord::Migration
  def change
    add_column :sales, :token, :string
  end
end
