class PackagesController < ApplicationController
  before_action :set_package, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_admin!, :only_autocrats

  # GET /packages
  # GET /packages.json
  def index
    @packages = Package.all
  end

  # GET /packages/1
  # GET /packages/1.json
  def show
  end

  # GET /packages/new
  def new
    @package = Package.new
    @tickets = Ticket.all
  end

  # GET /packages/1/edit
  def edit
    @tickets = Ticket.all
  end

  # POST /packages
  # POST /packages.json
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

    respond_to do |format|
      if @package.save
        format.html { redirect_to @package, notice: 'Package was successfully created.' }
        format.json { render :show, status: :created, location: @package }
      else
        format.html { render :new }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /packages/1
  # PATCH/PUT /packages/1.json
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

    respond_to do |format|
      if @package.update(filtered_params)
        format.html { redirect_to @package, notice: 'Package was successfully updated.' }
        format.json { render :show, status: :ok, location: @package }
      else
        format.html { render :edit }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /packages/1
  # DELETE /packages/1.json
  def destroy
    @package.destroy
    respond_to do |format|
      format.html { redirect_to packages_url, notice: 'Package was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_package
      @package = Package.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def package_params
      params[:package].permit(:name, :description, :price, :for_sale, :package_tickets_attributes => [:ticket_id, :quantity])
    end

    def only_autocrats
      if admin_signed_in?
        unless current_admin.autocratic
          flash[:alert] = "You are not authorized"
          redirect_to new_sale_path
        end
      end
    end
end

