class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  force_ssl if: :ssl_configured?
  helper_method :only_autocrats
  
  def only_autocrats
    if admin_signed_in?
      unless current_admin.autocratic
        flash[:alert] = "You are not authorized"
        redirect_to new_sale_path
      end
    end
  end

  private

  def ssl_configured?
    Rails.env.production?
  end
end
