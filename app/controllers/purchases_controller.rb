class PurchasesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :assign_packages, except: [:success]
  before_action :assign_purchase, only: [:success]
  before_action :authenticate_admin!, only: [:show, :redeem, :index]

  def index
    @purchases = Purchase.all
  end

  def show
    @purchase = Purchase.find_by(redemption_id: params[:id])
  end

  def redeem
    @purchase = Purchase.find_by(redemption_id: params[:redemption_id])
    @purchase.update_attribute(:redeemed_on, Date.today)

    redirect_to "/purchase/#{@purchase.redemption_id}"
  end

  def new
    @purchase = Purchase.new
  end

  def create
    puts "create"
    respond_to do |format|
      if @purchase = Purchase.create(quantity_params)
        format.html { redirect_to personal_info_path(redemption_id: @purchase.redemption_id) }
        format.js { render }
        format.json { render action: "personal_info", status: :success, redemption_id: @purchase.redemption_id }
      end
    end
  end

  def update_quantities
    puts "update_quantities"
    @purchase = Purchase.find_by(redemption_id: params[:purchase][:redemption_id])
    @purchase.purchased_packages.destroy_all # TODO be a bit more selective, not destroying all, but only those that become 0 quantity
    respond_to do |format|
      if @purchase.update_attributes(quantity_params)
        format.html { redirect_to personal_info_path(redemption_id: @purchase.redemption_id) }
        format.js { render }
        format.js { render action: "create" }
      end
    end

  end

  def update_personal_info
    puts "update_personal_info"
    @purchase = Purchase.find_by(redemption_id: params[:purchase][:redemption_id])

    respond_to do |format|
      if @purchase.update(personal_info_params)
        format.html { redirect_to collect_card_path(redemption_id: @purchase.redemption_id) }
        format.js { render }
        format.json { render action: "collect_card", status: :success, redemption_id: @purchase.redemption_id }
      else
        format.html { render action: "personal_info" }
        format.js { render }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  def charge
    @purchase = Purchase.find_by(redemption_id: params[:purchase][:redemption_id])

    begin
      puts "Total price on record is: #{@purchase.total_price}"
      puts "Total price calculated by JS is: #{(@purchase.js_calculated_price.to_i * 1.04).round}"

      if @purchase.total_price == (@purchase.js_calculated_price.to_i * 1.04).to_i
        charge = Stripe::Charge.create(
          :amount => @purchase.total_price,
          :currency => "usd",
          :source => params[:purchase][:stripe_token],
          :description => "test card charge"
        )

        @purchase.update_attribute(:charge_id, charge.id)

        CustomerMailer.receipt_email(@purchase).deliver_now

        redirect_to success_path(redemption_id: @purchase.redemption_id)
      else
        redirect_to failure_path
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

  def quantity_params
    params[:purchase].permit(:name, :email, :js_calculated_price, :collecting_quantity, purchased_packages_attributes: [ :quantity, :package_id ]).tap do |pp|
      pp[:purchased_packages_attributes].reject! {|k,v| v[:quantity].blank? || v[:quantity].to_s == "0"}
    end
  end

  def personal_info_params
    params[:purchase].permit(:name, :email, :redemption_id)
  end

  def charge_params
    params[:purchase].permit(:stripe_token, :redemption_id, :js_calculated_price)
  end
end
