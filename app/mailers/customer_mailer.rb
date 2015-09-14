class CustomerMailer < ApplicationMailer
  def receipt_email(sale)
    # TODO: Where to store images on Heroku
    @sale = sale

    io = StringIO.new
    @sale.redemption_qrcode.as_png.write(io)
    io.rewind

    attachments["#{@sale.redemption_code}.png"] = {
      :mime_type => 'image/png',
      :content => io.read
    }

    mail(to: @sale.email, subject: 'DeSoto Caverns receipt')
  end
end
