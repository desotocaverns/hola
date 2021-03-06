class PackagesController < ApplicationController
  include ApplicationHelper
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
    filtered_params[:price] = filtered_params[:price].to_f * 100
    for_sale = filtered_params[:for_sale] if filtered_params[:for_sale] != ""

    filtered_params[:package_tickets_attributes].each do |hash|
      if hash["quantity"] == "0"
        filtered_params[:package_tickets_attributes] = filtered_params[:package_tickets_attributes] - [hash]
      end
    end
    filtered_params.except!("for_sale")
    filtered_params.except!("for_sale_on(1i)", "for_sale_on(2i)", "for_sale_on(3i)") if for_sale

    @package = Package.new(filtered_params)
    @package.for_sale_on = Time.now if for_sale == "true"
    @tickets = Ticket.all

    if @package.save
      redirect_to tickets_path, notice: 'Package was successfully created.'
    else
      render :new
    end
  end

  def update
    PackageTicket.where("package_id = #{@package.id}").find_each do |pt|
      pt.delete
    end

    fixed_params = package_params
    fixed_params[:price] = (fixed_params[:price].to_f * 100).round
    for_sale = fixed_params[:for_sale] if fixed_params[:for_sale] != ""

    fixed_params[:package_tickets_attributes].each do |hash|
      if hash["quantity"] == "0"
        fixed_params[:package_tickets_attributes] = fixed_params[:package_tickets_attributes] - [hash]
      end
    end

    fixed_params[:for_sale_on] = Time.now if for_sale == "true"
    fixed_params[:for_sale_on] = nil if for_sale == "false"
    fixed_params[:for_sale_on] = Date.new(fixed_params["for_sale_on(1i)"].to_i, fixed_params["for_sale_on(2i)"].to_i, fixed_params["for_sale_on(3i)"].to_i) if for_sale == "after"

    fixed_params.except!("for_sale")
    fixed_params.except!("for_sale_on(1i)", "for_sale_on(2i)", "for_sale_on(3i)") if for_sale

    if @package.update(fixed_params)
      redirect_to tickets_path, notice: 'Package was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @package.destroy

    Package.all.order(:priority).last.priority = Package.all.order(:priority).last.priority - 1

    respond_to do |format|
      format.html { redirect_to auto_tickets_path(@package), notice: 'Package was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_package
      @package = Package.find(params[:id])
    end

    def package_params
      params[:package].permit(:name, :description, :price, :for_sale, :for_sale_on, :validity_interval, :package_tickets_attributes => [:ticket_id, :quantity])
    end
end
