class AdminsController < ApplicationController
  before_action :set_admin, only: [:edit, :active_for_authentication?]
  before_action :authenticate_admin!

  def index
    @admins = Admin.all
  end

  def edit
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)

    respond_to do |format|
      if @admin.save
        format.html { redirect_to admins_path, notice: 'Admin was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    @admin = Admin.find(params[:id])
    @admin.update_attribute(:activated, false)

    redirect_to admins_path
  end

  def show_deactivated

  end

  private

    def set_admin
      @admin = Admin.find(params[:id])
    end

    def admin_params
      params[:admin].permit(:email, :password)
    end
end
