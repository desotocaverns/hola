class CustomerMailer < ApplicationMailer
  def receipt_email(purchase)
    # TODO: Where to store images on Heroku
    @purchase = purchase

    qr_image_path = "#{Rails.root}/app/assets/images/#{@purchase.redemption_id}.png"

    begin
      @purchase.redemption_qrcode.as_png({:file => qr_image_path})
      attachments["qr.png"] = File.read(qr_image_path)
      mail(to: @purchase.email, subject: 'DeSoto Caverns receipt')
    ensure
      File.delete(qr_image_path) if File.exist?(qr_image_path)
    end
  end
end
