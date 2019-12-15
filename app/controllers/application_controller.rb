class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include AttendancesHelper
  
  def correct_user
    redirect_to(root_url) if current_user?(@user) || current_user.admin?
  end
  
  def correct_user_2
    @user = User.find(params[:id])
    redirect_to(root_url) unless @user == current_user
  end
  
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
