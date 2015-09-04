class CustomerMailer < ApplicationMailer
  def receipt_email(sale)
    # TODO: Where to store images on Heroku
    @sale = sale
    @purchases = @sale.purchases
    acc = 1

    @purchases.each do |purchase|
      purchase.redemption_codes.each do |rc|
        io = StringIO.new
        rc.redemption_qrcode.as_png.write(io)
        io.rewind

        attachments["#{acc.to_s}.png"] = {
          :mime_type => 'image/png',
          :content => io.read
        }

        acc = acc + 1
      end
    end

    mail(to: @sale.email, subject: 'DeSoto Caverns receipt')
  end
end
