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
    @sale = Sale.new(sale_params)

    ticket_params[:ticket_ids].each do |ticket_id, quantity|
      unless quantity == ""
        quantity.to_i.times do |i|
          purchase = TicketPurchase.new(ticket: Ticket.find_by(id: ticket_id))
          @sale.purchases << purchase
        end
      end
    end

    respond_to do |format|
      if @sale.save!
        format.html { redirect_to personal_info_path(token: @sale.token) }
        format.js { render }
        format.json { render action: "personal_info", status: :success, token: @sale.token}
      end
    end
  end

  def update_quantities
    @sale = Sale.find_by(token: params[:sale][:token])
    # @sale.sold_packages.destroy_all # TODO be a bit more selective, not destroying all, but only those that become 0 quantity
    respond_to do |format|
      if @sale.update_attributes(sale_params)
        format.html { redirect_to personal_info_path(redemption_id: @sale.redemption_id) }
        format.js { render }
        format.js { render action: "create" }
      end
    end
  end

  def update_personal_info
    @sale = Sale.find_by(token: params[:sale][:token])
    puts @sale.charge_total

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
    @sale = Sale.find_by(token: params[:sale][:token])

    begin
      puts "Total price on record is: #{@sale.charge_total}"
      puts "Stripe token is: #{params[:sale][:stripe_token]}"
      # puts "Total price calculated by JS is: #{(@sale.js_calculated_price.to_i * 1.04).round}"

      #if @sale.charge_total == (@sale.js_calculated_price.to_i * 1.04).to_i
      charge = Stripe::Charge.create(
        :amount => @sale.charge_total,
        :currency => "usd",
        :source => params[:sale][:stripe_token],
        :description => "test card charge"
      )

      @sale.update_attribute(:charge_id, charge.id)

      CustomerMailer.receipt_email(@sale).deliver_now

      redirect_to success_path(token: @sale.token)
      #else
        #redirect_to failure_path
      #end

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
    @sale = Sale.find_by(token: params[:token])
  end

  def sale_params
    params[:sale].permit(:token)
    #params[:sale].permit(:name, :email, :js_calculated_price, :collecting_quantity, sold_packages_attributes: [ :quantity, :package_id ]).tap do |pp|
      #pp[:sold_packages_attributes].reject! {|k,v| v[:quantity].blank? || v[:quantity].to_s == "0"}
    #end
  end

  def ticket_params
    params[:ticket].permit().tap do |whitelisted|
      whitelisted[:ticket_ids] = params[:ticket][:ticket_ids]
    end
  end

  def personal_info_params
    params[:sale].permit(:name, :email, :token)
    #params[:sale].permit(:name, :email, :redemption_id)
  end

  def charge_params
    params[:sale].permit(:stripe_token, :js_calculated_price)
    # params[:sale].permit(:stripe_token, :redemption_id, :js_calculated_price)
  end
end
