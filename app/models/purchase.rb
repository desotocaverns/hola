class Purchase < ActiveRecord::Base
  has_many :purchased_packages
  accepts_nested_attributes_for :purchased_packages, allow_destroy: false

  before_save :calculate_prices

  private

  def calculate_prices
    package_price = purchased_packages.inject(0) {|total, e| total + e.total_price}
    self.tax = package_price * 0.04
    self.total_price = package_price + self.tax
  end
end
