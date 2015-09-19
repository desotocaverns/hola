class AddSettingsTable < ActiveRecord::Migration
  def change
    create_table :settings, id: false do |s|
      s.primary_key :settings
      s.float :tax, default: 0.07
      s.string :company_email, default: "desotocaverns@donotreply.com"
    end
  end
end
