class SalesController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :assign_tickets, except: [:success]
  before_action :assign_sale, only: [:success]
  before_action :authenticate_admin!, only: [:show, :redeem, :index]

  def index
    @sales = Sale.all
  end

  def show
    @purchase = Purchase.find_by(redemption_code: params[:id])
    @sale = Sale.find_by(id: @purchase.sale_id)
  end

  def redeem
    @purchase = Purchase.find_by(redemption_code: params[:redemption_id])
    @purchase.update_attribute(:redeemed_on, Date.today)

    redirect_to "/sales/#{@purchase.redemption_code}"
  end

  def new
    @sale = Sale.new
  end

  def create
    respond_to do |format|
      if @sale = Sale.create(quantity_params)
        format.html { redirect_to personal_info_path(redemption_id: @sale.redemption_id) }
        format.js { render }
        format.json { render action: "personal_info", status: :success, redemption_id: @sale.redemption_id }
      end
    end
  end

  def update_quantities
    @sale = Sale.find_by(redemption_id: params[:sale][:redemption_id])
    @sale.sold_packages.destroy_all # TODO be a bit more selective, not destroying all, but only those that become 0 quantity
    respond_to do |format|
      if @sale.update_attributes(quantity_params)
        format.html { redirect_to personal_info_path(redemption_id: @sale.redemption_id) }
        format.js { render }
        format.js { render action: "create" }
      end
    end

  end

  def update_personal_info
    @sale = Sale.find_by(redemption_id: params[:sale][:redemption_id])

    respond_to do |format|
      if @sale.update(personal_info_params)
        format.html { redirect_to collect_card_path(redemption_id: @sale.redemption_id) }
        format.js { render }
        format.json { render action: "collect_card", status: :success, redemption_id: @sale.redemption_id }
      else
        format.html { render action: "personal_info" }
        format.js { render }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  def charge
    @sale = Sale.find_by(redemption_id: params[:sale][:redemption_id])

    begin
      puts "Total price on record is: #{@sale.total_price}"
      puts "Total price calculated by JS is: #{(@sale.js_calculated_price.to_i * 1.04).round}"

      if @sale.total_price == (@sale.js_calculated_price.to_i * 1.04).to_i
        charge = Stripe::Charge.create(
          :amount => @sale.total_price,
          :currency => "usd",
          :source => params[:sale][:stripe_token],
          :description => "test card charge"
        )

        @sale.update_attribute(:charge_id, charge.id)

        CustomerMailer.receipt_email(@sale).deliver_now

        redirect_to success_path(redemption_id: @sale.redemption_id)
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

  def assign_tickets
    @tickets = Ticket.for_sale.all
  end

  def assign_sale
    @sale = Sale.find_by_redemption_id(params[:redemption_id])
  end

  def quantity_params
    params[:sale].permit(:name, :email, :js_calculated_price, :collecting_quantity, sold_packages_attributes: [ :quantity, :package_id ]).tap do |pp|
      pp[:sold_packages_attributes].reject! {|k,v| v[:quantity].blank? || v[:quantity].to_s == "0"}
    end
  end

  def personal_info_params
    params[:sale].permit(:name, :email, :redemption_id)
  end

  def charge_params
    params[:sale].permit(:stripe_token, :redemption_id, :js_calculated_price)
  end
end
