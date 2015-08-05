class PurchaseController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def charge
    Stripe.api_key = "sk_test_eLKTszC60IfG8ZhzhNJfnSek"

    begin
      purchase = Purchase.create!(purchase_params)

      charge = Stripe::Charge.create(
        :amount => purchase.total_price,
        :currency => "usd",
        :source => purchase.stripe_token,
        :description => "test card charge"
      )

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
    end
  end

  private

  def purchase_params
    params[:purchase].permit(:name, :stripe_token, purchased_packages_attributes: [ [ :quantity, :package_id ] ])
  end
end
