class AddStripeTokenToPurchases < ActiveRecord::Migration
  def change
    add_column :purchases, :stripe_token, :string
  end
end
