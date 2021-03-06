class AdminsController < ApplicationController
  before_action :assign_admin, only: [:edit, :active_for_authentication?]
  before_action :authenticate_admin!, :only_autocrats

  def destroy
    @admin = Admin.find(params[:id])
    @admin.destroy

    redirect_to admins_path
  end

  private

    def assign_admin
      @admin = Admin.find(params[:id])
    end

    def admin_params
      params[:admin].permit(:email, :password)
    end
end
