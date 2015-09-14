require 'securerandom'

class Sale < ActiveRecord::Base

  scope :complete, -> { where("charge_id IS NOT NULL") }

  has_many :purchases, dependent: :destroy, after_remove: :purchase_removed

  before_create :generate_unique_token

  before_save :generate_redemption_code

  before_validation :calculate_prices

  attr_accessor :is_info_form

  validates_presence_of :purchases
  validate :must_have_quantities
  validates :name, :tax, :charge_total, presence: true, if: :is_info_form
  validates :email, email: true, presence: true, if: :is_info_form

  def redemption_qrcode
    RQRCode::QRCode.new("http://localhost:3000/purchase/#{redemption_code}")
  end

  private

  def calculate_prices
    subtotal = purchases.inject(0) {|total, e| total + e.price * e.quantity }
    self.tax = subtotal * 0.04
    self.charge_total = subtotal + self.tax
  end

  def purchase_removed(purchase)
    calculate_prices
    save(validate: false)
  end

  def generate_unique_token
    self.token = SecureRandom.urlsafe_base64(10) + self.id.to_s
  end

  def generate_redemption_code
    expiration_date = Time.now + 1.years
    expiration_date_string = expiration_date.strftime("%d%m%y")
    self.redemption_code = expiration_date_string + SecureRandom.urlsafe_base64(10)
  end

  def must_have_quantities
    if purchases.empty?
      errors.add(:quantities, "cannot be blank")
    end
  end
end
