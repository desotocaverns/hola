class Purchase < ActiveRecord::Base
  belongs_to :sales

  # has_many :package_purchases, dependant: :destroy
  # has_many :ticket_purchases, dependant: :destroy
  before_save :generate_redemption_id, :calculate_expiration_date

  def redemption_qrcode
    RQRCode::QRCode.new(redemption_url)
  end

  def redemption_url
    "http://localhost:3000/purchase/#{redemption_id}"
  end

  private

  #def calculate_prices
    #package_price = purchased_packages.inject(0) {|total, e| total + e.total_price}
    #self.tax = package_price * 0.04
    #self.total_price = package_price + self.tax
  #end

  def calculate_expiration_date
    expiration_date = Time.now + 1.years
    self.expires_on = expiration_date
  end

  def generate_redemption_id
    expiration_date = Time.now + 1.years
    expiration_date_string = expiration_date.strftime("%d%m%y")
    self.redemption_code = expiration_date_string + SecureRandom.urlsafe_base64(10)
  end
end
