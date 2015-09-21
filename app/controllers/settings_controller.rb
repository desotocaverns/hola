class SettingsController < ApplicationController
  before_action :authenticate_admin!

  def edit
    @settings = Settings()
  end

  def update
    @settings = Settings()
    @settings.update(settings_params)
    flash[:notice] = "Settings succesfully changed"
    redirect_to settings_path
  end

  private

  def settings_params
    params[:settings].permit(:tax, :company_email)
  end
end
