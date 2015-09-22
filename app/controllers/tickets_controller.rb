class TicketsController < ApplicationController
  before_action :authenticate_admin!, :only_autocrats

  def index
    @tickets = Ticket.all.order(:priority)
    @packages = Package.all.order(:priority)
    @current_tickets = Ticket.for_sale.order(:priority)
    @current_packages = Package.for_sale.order(:priority)
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

    if @ticket.save
      redirect_to @ticket, notice: 'Ticket was successfully created.'
    else
      render :new
    end
  end

  def update
    @ticket = Ticket.find_by(id: params[:id])
    fixed_params = ticket_params
    fixed_params[:price] = fixed_params[:price].to_f * 100

    assign_for_sale_on_date(fixed_params, @ticket)

    if @ticket.errors.empty?
      if @ticket.update(fixed_params)
        redirect_to @ticket, notice: 'Ticket was successfully updated.'
      else
        render :edit
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
    params[:ticket].permit(:name, :description, :price, :for_sale, :for_sale_on)
  end
end
