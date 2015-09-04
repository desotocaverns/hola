class RemoveCreatedAtAndUpdatedAtFromSomeTables < ActiveRecord::Migration
  def change
    remove_column :redemption_codes, :created_at
    remove_column :redemption_codes, :updated_at

    remove_column :tickets, :created_at
    remove_column :tickets, :updated_at

    remove_column :packages, :created_at
    remove_column :packages, :updated_at

    remove_column :package_tickets, :created_at
    remove_column :package_tickets, :updated_at

    remove_column :purchases, :created_at
    remove_column :purchases, :updated_at

    remove_column :ticket_revisions, :updated_at
    remove_column :package_revisions, :updated_at
  end
end
