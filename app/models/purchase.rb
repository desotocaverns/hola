class Purchase < ActiveRecord::Base
  has_many :purchased_packages
  accepts_nested_attributes_for :purchased_packages, allow_destroy: false

  before_validation :calculate_prices

  before_save :generate_redemption_id

  validates :name, :tax, :total_price, :email, presence: true
  validates :tax, numericality: { greater_than_or_equal_to: 0.20 }
  validates :total_price, numericality: { greater_than_or_equal_to: 4.99 }

  def redemption_qrcode
    RQRCode::QRCode.new(redemption_url)
  end

  def redemption_url
    "http://localhost:3000/redeem/#{redemption_id}"
  end

  private

  def calculate_prices
    package_price = purchased_packages.inject(0) {|total, e| total + e.total_price}
    self.tax = package_price * 0.04
    self.total_price = package_price + self.tax
  end

  def generate_redemption_id
    self.redemption_id = rand(10 ** 8) # TODO: seed based on time
  end
end
