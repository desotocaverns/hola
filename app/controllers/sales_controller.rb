class SalesController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :assign_tickets, except: [:success]
  before_action :assign_packages, except: [:success]
  before_action :assign_sale, only: [:success]
  before_action :authenticate_admin!, only: [:show, :redeem, :index]

  def index
    @sales = Sale.complete.where("name LIKE ? OR email LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%").paginate(:page => params[:page], :per_page => 20)
  end

  def show
    @redemption_code = RedemptionCode.find_by(code: params[:id])
    @purchase = Purchase.find_by(id: @redemption_code.purchase_id)
    @sale = Sale.find_by(id: @purchase.sale_id)
  end

  def redeem
    @redemption_code = RedemptionCode.find_by(code: params[:redemption_code])
    @purchase = Purchase.find_by(id: @redemption_code.purchase_id)
    @redemption_code.update_attribute(:claimed_on, Date.today)

    redirect_to "/sales/#{@redemption_code.code}"
  end

  def new
    if params[:token]
      @sale = Sale.find_by(token: params[:token])
    else
      @sale = Sale.new
    end
  end

  def create
    @sale = Sale.new(sale_params)

    if params[:sale].has_key?(:ticket)
      ticket_params[:ticket_ids].each do |ticket_id, quantity|
        unless quantity == "0"
          purchase = TicketPurchase.new(ticket: Ticket.find_by(id: ticket_id), quantity: quantity)
          @sale.purchases << purchase
        end
      end
    end

    if params[:sale].has_key?(:package)
      package_params[:package_ids].each do |package_id, quantity|
        unless quantity == "0"
          purchase = PackagePurchase.new(package: Package.find_by(id: package_id), quantity: quantity)
          @sale.purchases << purchase
        end
      end
    end

    respond_to do |format|
      if @sale.save
        format.html { redirect_to new_sale_path }
        format.js { render }
      else
        format.html { redirect_to new_sale_path }
        format.js { render }
      end
    end
  end

  def cart
    @sale = Sale.find_by(token: params[:token])
  end

  def update_cart
    @sale = Sale.find_by(token: params[:sale][:token])

    if params[:sale][:ticket]
      params[:sale][:ticket][:ticket_ids].each do |ticket_id, quantity|
        if @sale.purchases.where(ticket_revision_id: ticket_id).any?
          purchase = @sale.purchases.find_by(ticket_revision_id: ticket_id)

          quantity = quantity.to_i unless quantity == ""
          if params[:adding] == "true"
            quantity = purchase.quantity + quantity.to_i
          end

          if quantity == 0 || quantity == ""
            purchase.destroy
          else
            purchase.update(:quantity => quantity)
          end
        else
          purchase = TicketPurchase.new(ticket: Ticket.find_by(id: ticket_id), quantity: quantity)
          @sale.purchases << purchase
        end
      end
    end

    if params[:sale][:package]
      params[:sale][:package][:package_ids].each do |package_id, quantity|
        @sale.purchases.where(package_revision_id: package_id).destroy_all
        purchase = PackagePurchase.new(package: Package.find_by(id: package_id), quantity: quantity)
        @sale.purchases << purchase
      end
    end

    @sale.update_attributes(sale_params)

    if params[:adding] == ""
      redirect_to summary_path(token: @sale.token)
    end
  end

  def summary
    @sale = Sale.find_by(token: params[:token])
  end

  def update_personal_info
    @sale = Sale.find_by(token: params[:token])

    respond_to do |format|
      if @sale.update(update_personal_info_params)
        format.html { redirect_to collect_card_path(redemption_id: @sale.redemption_id) }
        format.js { render }
      else
        format.html { render action: "personal_info" }
        format.js { render }
      end
    end
  end

  def checkout
    @sale = Sale.find_by(token: params["token"])

    respond_to do |format|
      format.html { raise "format is HTML" }
      format.js { render }
    end
  end

  def charge
    @sale = Sale.find_by(token: sale_params[:token])

    begin
      charge = Stripe::Charge.create(
        :amount => @sale.charge_total,
        :currency => "usd",
        :source => params[:sale][:stripe_token],
        :description => "test card charge"
      )

      @sale.update_attribute(:charge_id, charge.id)

      CustomerMailer.receipt_email(@sale).deliver_now

      redirect_to success_path(token: @sale.token)

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

  # ASSIGNMENTS

  def assign_tickets
    @tickets = Ticket.for_sale.all
  end

  def assign_packages
    @packages = Package.for_sale.all
  end

  def assign_sale
    @sale = Sale.find_by(token: params[:token])
  end
 
  # PARAMS

  def sale_params
    params[:sale].permit(:ticket, :package, :token)
  end

  def ticket_params
    params[:sale][:ticket].permit().tap do |whitelisted|
      whitelisted[:ticket_ids] = params[:sale][:ticket][:ticket_ids]
    end
  end

  def package_params
    params[:sale][:package].permit().tap do |whitelisted|
      whitelisted[:package_ids] = params[:sale][:package][:package_ids]
    end
  end

  def update_personal_info_params
    params[:sale].permit(:name, :email, :token, :finalizing)
  end

  def charge_params
    params[:sale].permit(:stripe_token, :js_calculated_price)
  end
end
