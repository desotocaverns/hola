class SettingsController < ApplicationController
  before_action :authenticate_admin!, :only_autocrats

  def edit
    @settings = Settings()
  end

  def update
    @settings = Settings()
    if @settings.update(settings_params)
      flash[:notice] = "Settings succesfully changed"
    else
      flash[:alert] = "Your settings could not be saved because they were invalid"
    end

    redirect_to settings_path
  end

  private

  def settings_params
    params[:settings].permit(:tax, :company_email, :sale_notification_list)
  end
end
