class CustomerMailer < ApplicationMailer
  def receipt_email(sale)
    # TODO: Where to store images on Heroku
    @sale = sale
    @purchases = @sale.purchases
    acc = 1

    @purchases.each do |purchase|
      io = StringIO.new
      purchase.redemption_qrcode.as_png.write(io)
      io.rewind

      attachments["#{acc.to_s}.png"] = {
        :mime_type => 'image/png',
        :content => io.read
      }

      acc = acc + 1
    end

    mail(to: @sale.email, subject: 'DeSoto Caverns receipt')
  end
end
