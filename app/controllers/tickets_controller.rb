class TicketsController < ApplicationController
  before_action :authenticate_admin!, :only_autocrats

  def index
    @tickets = Ticket.all.order(:priority)
    @packages = Package.all.order(:priority)
  end

  def change_priority
    params[:type] == "Package" ? model = Package : model = Ticket
    @object = model.find_by(id: params[:id])
    priority = @object.priority

    if params.has_key?(:up)
      unless priority.to_i == 1
        updated_priority = priority - 1
        model.where("priority = #{updated_priority}").update_all("priority = priority + 1")
      end
    else
      unless priority == model.all.order(:priority).last.priority
        updated_priority = priority + 1
        model.where("priority = #{updated_priority}").update_all("priority = priority - 1")
      end
    end

    @object.update_attribute(:priority, updated_priority) if updated_priority

    redirect_to tickets_path
  end

  def show
    @ticket = Ticket.find_by(id: params[:id])
  end

  def new
    @ticket = Ticket.new
  end

  def edit
    @ticket = Ticket.find_by(id: params[:id])
  end

  def create
    fixed_params = ticket_params
    fixed_params[:price] = fixed_params[:price].to_f * 100
    @ticket = Ticket.new(fixed_params)

    respond_to do |format|
      if @ticket.save
        format.html { redirect_to @ticket, notice: 'Ticket was successfully created.' }
        format.json { render :show, status: :created, location: @package }
      else
        format.html { render :new }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @ticket = Ticket.find_by(id: params[:id])
    fixed_params = ticket_params
    fixed_params[:price] = fixed_params[:price].to_f * 100

    respond_to do |format|
      if @ticket.update(fixed_params)
        format.html { redirect_to @ticket, notice: 'Ticket was successfully updated.' }
        format.json { render :show, status: :ok, location: @ticket }
      else
        format.html { render :edit }
        format.json { render json: @ticket.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @ticket = Ticket.find_by(id: params[:id])

    @ticket.destroy

    Ticket.all.order(:priority).last.priority = Ticket.all.order(:priority).last.priority - 1

    respond_to do |format|
      format.html { redirect_to tickets_url, notice: 'Ticket was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def ticket_params
    params[:ticket].permit(:name, :description, :price, :for_sale)
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
