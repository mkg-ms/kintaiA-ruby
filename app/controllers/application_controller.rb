class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include AttendancesHelper
  
  def correct_user
    redirect_to(root_url) if current_user?(@user) || current_user.admin?
  end
  
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
