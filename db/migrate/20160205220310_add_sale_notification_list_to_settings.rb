class AddSaleNotificationListToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :sale_notification_list, :text
  end
end
