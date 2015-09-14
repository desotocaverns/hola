class RemoveRedemptionCodeTable < ActiveRecord::Migration
  def change
    drop_table :redemption_codes

    add_column :sales, :redemption_code, :string
    add_column :sales, :claimed_on, :date
  end
end
