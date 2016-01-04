class CustomerMailer < ApplicationMailer
  default from: "info@desotocavernspark.com"
  
  add_template_helper(ApplicationHelper)

  def receipt_email(sale, protohost)
    @sale = sale

    io = StringIO.new
    @sale.redemption_qrcode(protohost).as_png.write(io)
    io.rewind

    mail(to: @sale.email, from: Settings[:company_email], subject: 'DeSoto Caverns receipt')
  end
end
