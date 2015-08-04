class PurchaseController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def charge
    Stripe.api_key = "sk_test_eLKTszC60IfG8ZhzhNJfnSek"

    token = params[:token]
    customer_name = params[:customer_name]
    tax_amount = params[:tax_amount]
    charge_amount = params[:charge_amount]
    package_type = params[:package_type]
    ticket_quantity = params[:ticket_quantity]

    if package_type == 'Adult Caverns Tour ($21.99)'
      price_sans_tax = 21.99 * ticket_quantity.to_f
      puts price_sans_tax
      package_id = 1
    elsif package_type == 'Child Caverns Tour ($17.99)'
      price_sans_tax = 17.99 * ticket_quantity.to_f
      puts price_sans_tax
      package_id = 2
    else
      price_sans_tax = 4.99 * ticket_quantity.to_f
      puts price_sans_tax
      package_id = 3
    end

    precise_price = price_sans_tax * 1.04
    expected_price_string = sprintf '%.2f', precise_price
    expected_price = expected_price_string.to_f
    puts expected_price

    begin
      charge = Stripe::Charge.create(
        :amount => 1000,
        :currency => "usd",
        :source => token,
        :description => "test card charge"
      )

      if expected_price == charge_amount.to_f
        purchase = Purchase.create(name: customer_name, tax: tax_amount, total_price: charge_amount)
        purchased_package = PurchasedPackage.create(purchase_id: purchase.id, quantity: ticket_quantity, package_id: package_id)
      else
        puts "Could not save to database; expected price and price calculated by form were different."
        puts "Expected price was: #{expected_price}"
        puts "Price calculated by form was: #{charge_amount}"
      end

      redirect_to "/success"

    rescue Stripe::CardError => e
      body = e.json_body
      error  = body[:error]
      puts "Status is: #{e.http_status}"
      puts "Type is: #{error[:type]}"
      puts "Code is: #{error[:code]}"
      puts "Param is: #{error[:param]}"
      puts "Message is: #{error[:message]}"

    rescue Stripe::InvalidRequestError => e
      puts "Invalid parameters were sent to Stripe. Invalid currency, maybe?"

    rescue Stripe::AuthenticationError => e
      puts "Stripe authentication failed. Check the API key, maybe?"

    rescue Stripe::APIConnectionError => e
      puts "Network communication with Stripe failed. Do you have a stable internet connection?"

    rescue Stripe::StripeError => e
      puts "Something generic went wrong."

    rescue => e
      puts "Something is wrong with the code! Call in the programmers."
    end
  end
end
