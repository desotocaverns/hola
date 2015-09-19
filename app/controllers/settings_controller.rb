class SettingsController < ApplicationController
  before_action :authenticate_admin!

  def edit
    @settings = Settings.first
  end

  def update
    @settings = Settings.first
    @settings.update(settings_params)
    flash[:notice] = "Settings succesfully changed"
    redirect_to settings_path
  end

  private

  def settings_params
    params[:settings].permit(:tax, :company_email)
  end
end