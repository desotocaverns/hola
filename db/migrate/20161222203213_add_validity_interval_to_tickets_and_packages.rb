class AddValidityIntervalToTicketsAndPackages < ActiveRecord::Migration
  def change
    add_column :tickets, :validity_interval, :integer, default: 90
    add_column :packages, :validity_interval, :integer, default: 90
  end
end
