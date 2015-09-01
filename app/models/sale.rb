require 'securerandom'

class Sale < ActiveRecord::Base
  has_many :purchases

  # before_validation :calculate_prices

  # before_create :generate_redemption_id, :calculate_expiration_date

  validates :tax, numericality: { greater_than_or_equal_to: 0.20 }
  validates :total_price, numericality: { greater_than_or_equal_to: 4.99 }

  validates :name, :tax, :total_price, :email, presence: true,
            unless: :collecting_quantity
  validates :email, presence: true, email: true,
            unless: :collecting_quantity

  scope :complete, -> { where("charge_id IS NOT NULL") }

  attr_accessor :collecting_quantity

  private

  def calculate_prices
    subtotal = purchases.inject(0) {|total, e| total + e.total_price}
    self.tax = subtotal * 0.04
    self.total_price = subtotal + self.tax
  end

  def calculate_expiration_date
    expiration_date = Time.now + 1.years
    self.expires_on = expiration_date
  end
end
