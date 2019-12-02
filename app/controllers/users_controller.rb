class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  # before_action :correct_user,   only: [:show, :edit, :update]
  before_action :admin_user,     only: [:destroy, :edit_basic_info, :update_basic_info]
  

  def index
    @users = User.paginate(page: params[:page])
  end
  
  def import
    # ファイルセットされていたら保存と結果のメッセージを取得して表示
    if !params[:file].blank?
      # 保存と結果のメッセージを取得して表示
      User.import(params[:file])
      flash[:notice] = "CSVファイルをインポートしました。"
    else
      flash[:error] = "読み込むCSVファイルをセットしてください"
    end
    redirect_to users_path
  end
  
  def show
    @user = User.find(params[:id])
    @first_day = first_day(params[:first_day])
    @last_day = @first_day.end_of_month
    (@first_day..@last_day).each do |day|
      unless @user.attendances.any? {|attendance| attendance.worked_on == day}
        record = @user.attendances.build(worked_on: day)
        record.save
      end
    end
    @dates = user_attendances_month_date
    @worked_sum = @dates.where.not(started_at: nil).count
    respond_to do |format|
      format.html
      format.csv do
        send_data render_to_string, filename: "勤怠情報.csv", type: :csv
      end
    end
    @su_count = Attendance.where(superior_selector: @user.id).where.not(superior_selector: nil, superior_mark: 3).count
    @at_count = Attendance.where(superior_selection: @user.id).where.not(started_at_2: nil, attendance_mark: 3).count
    @count = Attendance.where(superior_select: @user.id).where.not(expected_end_time: nil, overtime_mark: 3).count
    @users = User.where(superior: true).where.not(id: @user.id)
    @attendance = Attendance.find(params[:id])
  end
  
  def show_confirmation
    @user = User.find(params[:id])
    @first_day = first_day(params[:first_day])
    @last_day = @first_day.end_of_month
    (@first_day..@last_day).each do |day|
      unless @user.attendances.any? {|attendance| attendance.worked_on == day}
        record = @user.attendances.build(worked_on: day)
        record.save
      end
    end
    @dates = user_attendances_month_date
    @worked_sum = @dates.where.not(started_at: nil).count
    @users = User.where(superior: true).where.not(id: @user.id)
    @attendance = Attendance.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "ユーザーの新規登録に成功しました。"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      if params[:commit] == "更新"
        redirect_to users_url
      else
        redirect_to edit_user_url
      end
    else
      render :edit
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "削除しました。"
    redirect_to users_url
  end
  # 未使用
  def edit_basic_info
    @user = User.find(params[:id])
  end
  # 未使用
  def update_basic_info
    @user = User.find(params[:id])
    if @user.update_attributes(basic_info_params)
      flash[:success] = "基本情報を更新しました。"
      redirect_to @user
    else
      render 'edit_basic_info' 
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :affiliation, :employee_number,
                                   :uid, :basic_work_time, :designated_work_start_time,
                                   :designated_work_end_time, :password, :password_confirmation)
    end
    
    def basic_info_params
      params.require(:user).permit(:basic_time, :work_time)
    end
    
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください。"
        redirect_to login_url
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
