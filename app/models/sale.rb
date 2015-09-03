require 'securerandom'

class Sale < ActiveRecord::Base

  scope :complete, -> { where("charge_id IS NOT NULL") }

  has_many :purchases, dependent: :destroy

  before_create :generate_unique_token

  before_validation :calculate_prices

  # Must be set to true when finalizing the Sale to ensure a valid Sale record.
  attr_accessor :finalizing
  validates :name, :tax, :charge_total, presence: true, if: :finalizing
  validates :email, email: true, presence: true, if: :finalizing

  # validates :tax, numericality: { greater_than_or_equal_to: 0.20 }
  # validates :charge_total, numericality: { greater_than_or_equal_to: 4.99 }

  private

  def calculate_prices
    subtotal = purchases.inject(0) {|total, e| total + e.price }
    self.tax = subtotal * 0.04
    self.charge_total = subtotal + self.tax
  end

  def generate_unique_token
    self.token = SecureRandom.urlsafe_base64(10) + self.id.to_s
  end
end
