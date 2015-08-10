class AddActivatedColumnToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :activated, :boolean, default: true
  end
end
