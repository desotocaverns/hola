class CustomerMailer < ApplicationMailer
  def receipt_email(purchase)
    @purchase = purchase
    mail(to: @purchase.email, subject: 'DeSoto Caverns receipt')
  end
end
