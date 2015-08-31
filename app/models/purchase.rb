class Purchase < ActiveRecord::Base
  belongs_to :sales

  # has_many :package_purchases, dependant: :destroy
  # has_many :ticket_purchases, dependant: :destroy

  def redemption_qrcode
    RQRCode::QRCode.new(redemption_url)
  end

  def redemption_url
    "http://localhost:3000/purchase/#{redemption_id}"
  end

  private

  def generate_redemption_id
    expiration_date = Time.now + 1.years
    expiration_date_string = expiration_date.strftime("%d%m%y")
    self.redemption_id = expiration_date_string + SecureRandom.urlsafe_base64(10)
  end
end
