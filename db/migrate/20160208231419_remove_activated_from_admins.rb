class RemoveActivatedFromAdmins < ActiveRecord::Migration
  def change
    remove_column :admins, :activated
  end
end
