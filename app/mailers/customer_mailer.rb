class CustomerMailer < ApplicationMailer
  def receipt_email(purchase)
    @purchase = purchase
    RQRCode::QRCode.new('http://www.google.com/').as_png({:file => 'app/assets/images/qr.png'})
    attachments["qr.png"] = File.read("#{Rails.root}/app/assets/images/qr.png")
    mail(to: @purchase.email, subject: 'DeSoto Caverns receipt')
    File.delete('app/assets/images/qr.png') if File.exist?('app/assets/images/qr.png')
  end
end
