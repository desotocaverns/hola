class AddMailingListStatusToSales < ActiveRecord::Migration
  def change
    add_column :sales, :mailing_list, :boolean
  end
end
