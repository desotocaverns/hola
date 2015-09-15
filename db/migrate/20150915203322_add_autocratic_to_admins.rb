class AddAutocraticToAdmins < ActiveRecord::Migration
  def change
    add_column :admins, :autocratic, :boolean, default: false
  end
end
