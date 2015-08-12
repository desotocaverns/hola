class ChangeDefaultOfActivated < ActiveRecord::Migration
  def change
    change_column :admins, :activated, :boolean, :default => false
  end
end
