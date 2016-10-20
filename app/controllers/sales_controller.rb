require "constantcontact"

class SalesController < ApplicationController
  layout 'public'
  skip_before_action :verify_authenticity_token

  before_action :set_cache_buster
  before_action :authenticate_admin!, only: [:show, :redeem, :index]

  before_action :assign_tickets, :assign_packages, except: [:receipt]
  before_action :assign_sale, except: [:index, :new, :create]
  before_action :check_completion, except: [:index, :show, :new, :receipt, :redeem, :resend_email]

  def index
    @sales = Sale.complete.where("lower(name) LIKE ? OR lower(email) LIKE ?", "%#{(params[:search] || '').downcase}%", "%#{(params[:search] || '').downcase}%").order('created_at DESC').paginate(:page => params[:page], :per_page => 20)
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
    CustomerMailer.redemption_email(@sale).deliver_now
    redirect_to "/sales/#{@sale.redemption_code}"
  end

  def update_cart
    update_cart_items

    @sale.update_attributes(sale_params)

    if params[:adding].to_s == ""
      if @sale.purchases.empty?
        redirect_to edit_sale_path(@sale)
      else
        respond_to do |format|
          format.js { render }
        end
      end
    end
  end

  def update_cart_items
    if params[:sale][:ticket]
      params[:sale][:ticket][:ticket_ids].each do |ticket_id, quantity|
        revision_id = Ticket.find_by(id: ticket_id).revisions.last.id
        if @sale.purchases.where(ticket_revision_id: revision_id).any?
          purchase = @sale.purchases.find_by(ticket_revision_id: revision_id)

          if quantity =~ /^\d+$/i
            quantity = quantity.to_i
            if params[:adding] == "true"
              quantity = purchase.quantity + quantity.to_i
            end

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
        revision_id = Package.find_by(id: package_id).revisions.last.id
        if @sale.purchases.where(package_revision_id: revision_id).any?
          purchase = @sale.purchases.find_by(package_revision_id: revision_id)

          if quantity =~ /^\d+$/i
            quantity = quantity.to_i
            if params[:adding] == "true"
              quantity = purchase.quantity + quantity.to_i
            end

            purchase.update(:quantity => quantity)
          end
        else
          purchase = PackagePurchase.new(package: Package.find_by(id: package_id), quantity: quantity)
          @sale.purchases << purchase
        end
      end
    end
  end

  def delete_purchase
    @sale.purchases.destroy(params[:purchase_id])

    if @sale.purchases.empty?
      redirect_to edit_sale_path(@sale)
    else
      redirect_to summarize_sale_path(@sale)
    end
  end

  def update_personal_info
    update_cart_items
    @sale.update(all_params)

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

      if Settings[:sale_notification_list] != nil
        admin_emails = Settings[:sale_notification_list].gsub(/\s+/, "").split(",")
        for email in admin_emails
          CustomerMailer.admin_receipt_email(@sale, email).deliver_now
        end
      end

      if Rails.env == "production"
        if @sale.mailing_list
          constant_contact = ConstantContact::Api.new(ENV["CONSTANT_CONTACT_API_KEY"], ENV["CONSTANT_CONTACT_OAUTH_TOKEN"])

          json = {
            "lists": [
                {"id": "1798215372"}
              ],
            "email_addresses": [
              {"email_address": "#{@sale.email}"}
            ]
          }

          begin
            constant_contact.add_contact(json, true)
          rescue RestClient::BadRequest => e
            puts "#{e.http_code} - #{e.http_body}"
          rescue RestClient::Conflict => e
            puts "This email address already exists in ConstantContact."
          rescue
            puts "ERROR: An unknown problem was encountered while trying to add this email address to ConstantContact."
          end
        end
      end

      redirect_to receipt_sale_path(@sale)

    rescue Stripe::CardError => e
      body = e.json_body
      error = body[:error]
      puts "Status is: #{e.http_status}"
      puts "Type is: #{error[:type]}"
      puts "Code is: #{error[:code]}"
      puts "Param is: #{error[:param]}"
      puts "Message is: #{error[:message]}"
      redirect_to failure_path

    rescue Stripe::InvalidRequestError => e
      puts "Invalid parameters were sent to Stripe. Invalid currency, maybe?"
      redirect_to failure_path

    rescue Stripe::AuthenticationError => e
      puts "Stripe authentication failed. Check the API key, maybe?"
      redirect_to failure_path

    rescue Stripe::APIConnectionError => e
      puts "Network communication with Stripe failed. Do you have a stable internet connection?"
      redirect_to failure_path

    rescue Stripe::StripeError => e
      puts "Something generic went wrong."
      redirect_to failure_path
    end
  end

  def resend_email
    @sale = Sale.find_by(redemption_code: params[:redemption_code])
    CustomerMailer.receipt_email(@sale, @sale.email, protohost).deliver_now
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

  def all_params
    params[:sale].permit(:ticket, :package, :name, :email, :is_info_form, :mailing_list)
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
    params[:sale].permit(:name, :email, :is_info_form, :mailing_list)
  end
end
