class SalesController < ApplicationController
  skip_before_action :verify_authenticity_token

  before_action :set_cache_buster
  before_action :authenticate_admin!, only: [:show, :redeem, :index]
  
  before_action :assign_tickets, :assign_packages, except: [:successful]
  before_action :assign_sale, except: [:index, :new, :create]
  before_action :check_completion, only: [:update_cart, :delete_purchase, :edit_personal_info, :checkout, :charge]

  def index
    @sales = Sale.complete.where("name LIKE ? OR email LIKE ?", "%#{params[:search]}%", "%#{params[:search]}%").paginate(:page => params[:page], :per_page => 20)
  end

  def new
    @sale = Sale.new
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

    @sale.save
    
    respond_to do |format|
      format.html { redirect_to new_sale_path }
      format.js { render }
    end
  end

  def show
    @purchase = Purchase.find_by(sale_id: @sale.id)
  end

  def redeem
    @sale.update_attribute(:claimed_on, Date.today)
    redirect_to "/sales/#{@sale.redemption_code}"
  end

  def update_cart
    if params[:sale][:ticket]
      params[:sale][:ticket][:ticket_ids].each do |ticket_id, quantity|
        if @sale.purchases.where(ticket_revision_id: ticket_id).any?
          purchase = @sale.purchases.find_by(ticket_revision_id: ticket_id)

          quantity = quantity.to_i unless quantity == ""
          if params[:adding] == "true"
            quantity = purchase.quantity + quantity.to_i
          end

          if quantity == 0 || quantity == ""
            unless purchase.destroy
              flash[:alert] = "Cannot destroy every purchase"
            end
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
        if @sale.purchases.where(package_revision_id: package_id).any?
          purchase = @sale.purchases.find_by(package_revision_id: package_id)

          quantity = quantity.to_i unless quantity == ""
          if params[:adding] == "true"
            quantity = purchase.quantity + quantity.to_i
          end

          if quantity == 0 || quantity == ""
            unless purchase.destroy
              flash[:alert] = "Cannot destroy every purchase"
            end
          else
            purchase.update(:quantity => quantity)
          end
        else
          purchase = PackagePurchase.new(package: Package.find_by(id: package_id), quantity: quantity)
          @sale.purchases << purchase
        end
      end
    end

    @sale.update_attributes(sale_params)

    if params[:adding].to_s == ""
      if @sale.purchases.empty?
        redirect_to edit_sale_path(@sale)
      else
        redirect_to summarize_sale_path(@sale)
      end
    end
  end

  def delete_purchase
    @sale.purchases.destroy(params[:purchase_id])

    if @sale.purchases.empty?
      redirect_to edit_sale_path(@sale)
    else
      redirect_to cart_path(@sale)
    end
  end

  def edit_personal_info
    respond_to do |format|
      format.js { render }
    end
  end

  def update_personal_info
    @sale.update(update_personal_info_params)
    respond_to do |format|
      format.js { render }
    end
  end

  def checkout
    respond_to do |format|
      format.js { render }
    end
  end

  def charge
    begin
      charge = Stripe::Charge.create(
        :amount => @sale.charge_total,
        :currency => "usd",
        :source => params[:sale][:stripe_token],
        :description => "test card charge"
      )

      @sale.update_attribute(:charge_id, charge.id)

      CustomerMailer.receipt_email(@sale, protohost).deliver_now

      redirect_to successful_sale_path(@sale)

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

  def resend_email
    @sale = Sale.find_by(redemption_code: params[:redemption_code])
    CustomerMailer.receipt_email(@sale, protohost).deliver_now
    redirect_to sale_path(@sale.redemption_code)
  end

  private

  def check_completion
    if @sale && @sale.charge_id
      redirect_to new_sale_path
    end
  end

  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def protohost
    return request.protocol + request.host unless request.local?
    return "http://localhost"
  end

  # ASSIGNMENTS

  def assign_tickets
    @tickets = Ticket.for_sale.all.order('priority')
  end

  def assign_packages
    @packages = Package.for_sale.all.order('priority')
  end

  def assign_sale
    @sale = Sale.find_by(redemption_code: params[:redemption_code])
  end
 
  # PARAMS

  def sale_params
    params[:sale].permit(:ticket, :package)
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
    params[:sale].permit(:name, :email, :is_info_form)
  end
end
