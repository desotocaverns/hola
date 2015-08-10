class CustomerMailer < ApplicationMailer
  def receipt_email(purchase)
    # TODO: Where to store images on Heroku
    @purchase = purchase

    io = StringIO.new
    @purchase.redemption_qrcode.as_png.write(io)
    io.rewind

    attachments["qr.png"] = {
      :mime_type => 'image/png',
      :content => io.read
    }

    mail(to: @purchase.email, subject: 'DeSoto Caverns receipt')
  end
end
