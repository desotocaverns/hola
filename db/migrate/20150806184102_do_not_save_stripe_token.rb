class DoNotSaveStripeToken < ActiveRecord::Migration
  def change
    remove_column :purchases, :stripe_token
  end
end
