class CustomerMailerPreview < ActionMailer::Preview
  def successful
    @sale = Sale.last

    io = StringIO.new
    @sale.redemption_qrcode(protohost).as_png.write(io)
    io.rewind

    attachments["#{@sale.redemption_code}.png"] = {
      :mime_type => 'image/png',
      :content => io.read
    }

    CustomerMailer.receipt_email(@sale, "http://localhost:3000/").message
  end

  def protohost
    return "http://localhost"
  end
end
