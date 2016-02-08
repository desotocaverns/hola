require 'securerandom'

class Sale < ActiveRecord::Base

  scope :complete, -> { where("charge_id IS NOT NULL") }

  has_many :purchases, dependent: :destroy, after_remove: :purchase_removed

  before_create :generate_redemption_code

  before_validation :calculate_prices

  attr_accessor :is_info_form

  validates_presence_of :purchases
  validate :must_have_quantities
  validates :name, :tax, :charge_total, presence: true, if: :is_info_form
  validates :email, email: true, if: :is_info_form

  def redemption_qrcode(protohost)
    RQRCode::QRCode.new("#{File.join(protohost, 'sales', redemption_code)}")
  end

  def ready_for_checkout?
    !self.email.nil? && !self.name.nil?
  end

  def qr_svg(url)
    svg = redemption_qrcode(url).as_svg({module_size: 5})
    svg.sub(/width="(.+?)"/, 'width="100%"').sub(/height="(.+?)"/, 'viewBox="0 0 \1 \1" class="qrcode"').html_safe
  end

  def qr_png(protohost, size=800)
    png = self.redemption_qrcode(protohost).as_png(size: size, border_modules: 2)
    png.to_data_url
  end

  def complete?
    !charge_id.nil?
  end

  def to_param
    redemption_code
  end

  def receipt_url(url)
    File.join(url, 'sales', redemption_code, 'receipt')
  end

  def claimed?
    !self.claimed_on.nil? 
  end

  private

  def calculate_prices
    subtotal = purchases.inject(0) {|total, e| total + e.price * e.quantity }
    self.tax = subtotal * Settings[:tax]
    self.charge_total = subtotal + self.tax
  end

  def purchase_removed(purchase)
    calculate_prices
    save(validate: false)
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
