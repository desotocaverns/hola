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
    @tickets = Ticket.all

    if @package.save
      redirect_to @package, notice: 'Package was successfully created.'
    else
      render :new
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
end
