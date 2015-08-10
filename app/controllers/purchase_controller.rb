class PurchaseController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :assign_packages, except: [:success]
  before_action :assign_purchase, only: [:success]

  def index
    @purchase = Purchase.new
    @ticket_pricing = @packages.to_json(except: [:created_at, :updated_at, :for_sale])
  end

  def show
    @purchase = Purchase.find_by(redemption_id: params[:id])
  end

  def redeem
    @purchase = Purchase.find_by(redemption_id: params[:id])
    @purchase.update_attribute(:redeemed_at, Date.today)

    redirect_to "/purchase/#{@purchase.redemption_id}"
  end

  def create
    Stripe.api_key = "sk_test_eLKTszC60IfG8ZhzhNJfnSek"

    begin
      @purchase = Purchase.new(purchase_params)

      if @purchase.valid?
        charge = Stripe::Charge.create(
          :amount => @purchase.total_price,
          :currency => "usd",
          :source => params[:purchase][:stripe_token],
          :description => "test card charge"
        )

        @purchase.charge_id = charge.id
        @purchase.save

        CustomerMailer.receipt_email(@purchase).deliver_now

        redirect_to "/purchase/success/#{@purchase.redemption_id}" # purchase_index_path(:redemption_id => @purchase.redemption_id, :name => @purchase.name)
      else
        session[:purchase] = params[:purchase]
        render :index
      end


    rescue Stripe::CardError => e
      body = e.json_body
      error = body[:error]
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

  def assign_packages
    @packages = Package.for_sale.all
  end

  def assign_purchase
    @purchase = Purchase.find_by_redemption_id(params[:redemption_id])
  end

  def purchase_params
    params[:purchase].permit(:name, :email, purchased_packages_attributes: [ :quantity, :package_id ]).tap do |pp|
      pp[:purchased_packages_attributes].reject! {|k,v| v[:quantity].blank? || v[:quantity].to_s == "0"}
    end
  end
end
