class AddJsPriceToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :js_calculated_price, :integer
  end
end
