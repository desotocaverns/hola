class DoNotSaveMaskedCardData < ActiveRecord::Migration
  def change
    remove_column :purchases, :masked_cc_number
    remove_column :purchases, :masked_cvc
    remove_column :purchases, :cc_expiration_date
  end
end
