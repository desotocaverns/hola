class RedemptionCode < ActiveRecord::Base
  belongs_to :purchases

  def redemption_qrcode
    RQRCode::QRCode.new("http://localhost:3000/purchase/#{code}")
  end
end
