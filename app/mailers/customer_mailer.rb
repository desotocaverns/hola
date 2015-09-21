class CustomerMailer < ApplicationMailer
  default from: "desotocaverns@donotreply.com"

  def receipt_email(sale, protohost)
    @sale = sale
    @settings = Settings.first

    io = StringIO.new
    @sale.redemption_qrcode(protohost).as_png.write(io)
    io.rewind

    attachments["#{@sale.redemption_code}.png"] = {
      :mime_type => 'image/png',
      :content => io.read
    }

    mail(to: @sale.email, from: @settings.company_email, subject: 'DeSoto Caverns receipt')
  end
end
