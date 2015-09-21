class PackagesController < ApplicationController
  before_action :set_package, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!, :only_autocrats

  def show
  end

  def new
    @package = Package.new
    @tickets = Ticket.all
  end

  def edit
    @packages = Package.all
    @tickets = Ticket.all
  end

  def create
    filtered_params = package_params

    filtered_params[:package_tickets_attributes].each do |hash|
      if hash["quantity"] == ""
        filtered_params[:package_tickets_attributes] = filtered_params[:package_tickets_attributes] - [hash]
      end
    end

    filtered_params[:price] = filtered_params[:price].to_f * 100

    @package = Package.new(filtered_params)
    assign_for_sale_on_date(filtered_params, @package)

    @tickets = Ticket.all

    if @package.errors.empty?
      if @package.save
        redirect_to @package, notice: 'Package was successfully created.'
      else
        render :new
      end
    end
  end

  def update
    PackageTicket.where("package_id = #{@package.id}").find_each do |pt|
      pt.delete
    end

    filtered_params = package_params

    filtered_params[:package_tickets_attributes].each do |hash|
      if hash["quantity"] == ""
        filtered_params[:package_tickets_attributes] = filtered_params[:package_tickets_attributes] - [hash]
      end
    end

    filtered_params[:price] = filtered_params[:price].to_f * 100

    assign_for_sale_on_date(filtered_params, @package)

    if @package.errors.empty?
      if @package.update(filtered_params)
        redirect_to @package, notice: 'Package was successfully updated.'
      else
        render :edit
      end
    end
  end

  def destroy
    @package.destroy

    Package.all.order(:priority).last.priority = Package.all.order(:priority).last.priority - 1

    respond_to do |format|
      format.html { redirect_to tickets_url, notice: 'Package was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_package
      @package = Package.find(params[:id])
    end

    def package_params
      params[:package].permit(:name, :description, :price, :for_sale_on, :package_tickets_attributes => [:ticket_id, :quantity])
    end

    def assign_for_sale_on_date(params, package)
      begin
        date = DateTime.new(params["for_sale_on(1i)"].to_i, params["for_sale_on(2i)"].to_i, params["for_sale_on(3i)"].to_i)
        package.update_attribute(:for_sale_on, date)
      rescue ArgumentError
        package.errors.add(:for_sale_on, "has an invalid date")
        @tickets = Ticket.all
        render action: 'new'
      end
    end
end
