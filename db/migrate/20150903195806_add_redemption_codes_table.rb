class AddRedemptionCodesTable < ActiveRecord::Migration
  def change
    remove_column :purchases, :redemption_code
    remove_column :purchases, :redeemed_on
    add_column :purchases, :token, :string, null: false
    add_column :purchases, :quantity, :integer, null: false, default: 1
  end
end
