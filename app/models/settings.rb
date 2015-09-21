class Settings < ActiveRecord::Base
  validates :company_email, presence: true
  validates_numericality_of :tax, greater_than_or_equal_to: 0.01

  def self.[](k)
    (first || default_settings)[k]
  end

  def self.default_settings
    Settings.create!
  end
end
