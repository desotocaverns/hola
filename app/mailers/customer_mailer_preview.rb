class CustomerMailerPreview < ActionMailer::Preview
  def successful
    @sale = Sale.last
    CustomerMailer.receipt_email(@sale, "http://localhost:3000/").message
  end
end
