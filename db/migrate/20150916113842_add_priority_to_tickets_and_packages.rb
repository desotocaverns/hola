class AddPriorityToTicketsAndPackages < ActiveRecord::Migration
  def change
    add_column :tickets, :priority, :integer
    add_column :packages, :priority, :integer
  end
end
