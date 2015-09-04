class CreateRedemptionCodes < ActiveRecord::Migration
  def change
    create_table :redemption_codes do |t|
      t.integer :purchase_id
      t.string :code
      t.date :claimed_on

      t.timestamps null: false
    end
  end
end
