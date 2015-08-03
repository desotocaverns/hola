class PurchaseController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def charge
    Stripe.api_key = "sk_test_eLKTszC60IfG8ZhzhNJfnSek"
    token = params[:token]

    begin
      charge = Stripe::Charge.create(
        :amount => 1000,
        :currency => "usd",
        :source => token,
        :description => "test card charge"
      )

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

    redirect_to "/success"
  end
end
