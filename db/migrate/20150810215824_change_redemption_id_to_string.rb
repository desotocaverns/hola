class ChangeRedemptionIdToString < ActiveRecord::Migration
  def change
    change_column :purchases, :redemption_id, :string
  end
end
