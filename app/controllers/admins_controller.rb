class AdminsController < ApplicationController
  before_action :set_admin, only: [:edit, :active_for_authentication?]
  before_action :authenticate_admin!

  def index
    @admins = Admin.all
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
