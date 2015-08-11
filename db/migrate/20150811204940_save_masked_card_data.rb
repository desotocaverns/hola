class SaveMaskedCardData < ActiveRecord::Migration
  def change
    add_column :purchases, :masked_cc_number, :string
    add_column :purchases, :masked_cvc, :string
    add_column :purchases, :cc_expiration_date, :string
  end
end
