class CustomerMailer < ApplicationMailer
  default from: "info@desotocavernspark.com"

  add_template_helper(ApplicationHelper)

  def receipt_email(sale, email, protohost)
    @sale = sale

    io = StringIO.new
    @sale.redemption_qrcode(protohost).as_png(size: 800, border_modules: 2).write(io)
    io.rewind

    attachments.inline["redemption_qrcode.png"] = {
      :mime_type => 'image/png',
      :content => io.read
    }

    mail(to: email, from: Settings[:company_email], subject: 'DeSoto Caverns receipt')
  end

  def redemption_email(sale, protohost)
    @sale = sale
    mail(to: @sale.email, from: Settings[:company_email], subject: 'Thanks for visiting!')
  end
end
