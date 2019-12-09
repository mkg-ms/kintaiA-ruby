class AttendancesController < ApplicationController
  before_action :admin_user, only: :index
  
  def index
    @workers = Attendance.worker
  end

  def create
    @user = User.find(params[:user_id])
    @attendance = @user.attendances.find_by(worked_on: Date.today)
    if @attendance.started_at.nil?
      @attendance.update_attributes(started_at: current_time)
      flash[:info] = 'おはようございます。'
    elsif @attendance.finished_at.nil?
      @attendance.update_attributes(finished_at: current_time)
      flash[:info] = "おつかれさまでした。"  
    else
      flash[:danger] = 'トラブルがあり、登録出来ませんでした。'
    end
    redirect_to @user
  end
  
  # 所属長承認申請
  def update_one_month
    @user = User.find(params[:id])
    @first_day = first_day(params[:first_day])
    @attendance = Attendance.find_by(worked_on: params[:date], user_id: @user.id)
    if @attendance.update(superior_selector: params[:superior_selector], superior_mark: 2)
      flash[:success] = "所属長承認を申請しました。"
      redirect_to user_path(@user)
    else
      flash[:danger] = "不正な時間入力がありました、再入力してください。"
      redirect_to edit_attendances_path(@user, params[:date])
    end
  end
  # 所属長承認申請お知らせモーダル
  def edit_superior_notice
    @user = User.find(params[:id])
    @users = User.application_manager_approval(superior: current_user)
    @attendance = Attendance.find_by(worked_on: params[:date], user_id: @user.id)
    @attendances = Attendance.where.not(worked_on: nil).where(superior_selector: @user.id)
  end
  
  def update_superior_notice
    @user = User.find(params[:id])
    @users = User.application_manager_approval(superior: current_user)
    @attendance = Attendance.find_by(worked_on: params[:date], user_id: @user.id)
    @attendances = Attendance.where.not(worked_on: nil).where(superior_selector: @user.id)
    if superior_notice_params.each do |id,item|
        if item["superior_change"] == "1"
         attendance = Attendance.find(id)
         attendance.update_attributes!(item)
        end
       end
      flash[:success] = "所属長承認申請についてを回答しました。"
      redirect_to user_path(@user)
    else
      flash[:danger] = "不正な時間入力がありました、再入力してください。"
      redirect_to edit_attendances_path(@user, params[:date])
    end
  end
  
  # 勤怠変更申請
  def edit
    @user = User.find(params[:id])
    @attendance = Attendance.find(params[:id])
    @first_day = first_day(params[:date])
    @last_day = @first_day.end_of_month
    @dates = user_attendances_month_date
  end

  def update
    @user = User.find(params[:id])
    @attendance = Attendance.find(params[:id])
    @first_day = first_day(params[:date])
    @last_day = @first_day.end_of_month
    @dates = user_attendances_month_date
    if attendances_invalid?
      attendances_params.each do |id,item|
        @attendance = Attendance.find(id)
        @attendance.update_attributes!(item)
        @attendance.update_attributes(attendance_mark: 2)
      end
      flash[:success] = "勤怠編集情報を更新しました。"
      redirect_to user_path(@user, params:{first_day: params[:date]})
    else
      flash[:danger] = "不正な入力がありました、再入力してください。"
      redirect_to edit_attendances_path(@user, params[:date])
    end
    rescue
      render :edit
  end
  
  # 勤怠変更申請お知らせモーダル
  def edit_attendance_notice
    @user = User.find(params[:id])
    @users = User.attendance_change(superior: current_user)
    @attendance = Attendance.find(params[:id])
    @attendances = Attendance.where.not(started_at_2: nil).where(superior_selection: @user.id)
  end
  
  def update_attendance_notice
    @user = User.find(params[:id])
    @users = User.attendance_change(superior: current_user)
    @attendance = Attendance.find(params[:id])
    @attendances = Attendance.where.not(started_at_2: nil).where(superior_selection: @user.id)
    if attendance_notice_params.each do |id,item|
        if item["attendance_change"] == "1"
          attendance = Attendance.find(id)
          attendance.update_attributes(item)
        end
       end
      flash[:success] = "勤怠変更申請についてを回答しました。"
      redirect_to user_path(@user)
    else
      flash[:danger] = "不正な時間入力がありました、再入力してください。"
      redirect_to edit_attendances_path(@user, params[:date])
    end
  end
  
  # 残業申請
  def edit_overtime
    @user = User.find(params[:id])
    @day = Date.parse(params[:date])
    @attendance = @user.attendances.find_by(worked_on: params[:date])
    @first_day = first_day(params[:date])
    @last_day = @first_day.end_of_month
    @dates = user_attendances_month_date
  end
  
  def update_overtime
    @user = User.find(params[:id])
    if overtime_notice_params.each do |id,item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
        attendance.update_attributes!(overtime_mark: 2)
       end
      flash[:success] = "残業申請情報を更新しました。"
      redirect_to user_path(@user)
    else
      flash[:danger] = "不正な時間入力がありました、再入力してください。"
      redirect_to edit_attendances_path(@user, params[:date])
    end
  end
  # 残業申請お知らせモーダル
  def edit_overtime_notice
    @user = User.find(params[:id])
    @users = User.overtime_applied_users(superior: current_user)
    @attendance = Attendance.find(params[:id])
    @attendances = Attendance.where.not(expected_end_time: nil).where(superior_select: @user.id)
  end
  
  def update_overtime_notice
    @user = User.find(params[:id])
    @users = User.overtime_applied_users(superior: current_user)
    @attendance = Attendance.find(params[:id])
    @attendances = Attendance.where.not(expected_end_time: nil).where(superior_select: @user.id)
    if overtime_notice_params.each do |id,item|
        if item["overtime_change"] == "1"
         attendance = Attendance.find(id)
         attendance.update_attributes!(item)
        end
       end
      flash[:success] = "残業申請についてを回答しました。"
      redirect_to user_path(@user)
    else
      flash[:danger] = "不正な時間入力がありました、再入力してください。"
      redirect_to edit_attendances_path(@user, params[:date])
    end
  end
  
  # 勤怠ログ
  def time_log
    @logs = Attendance.where(attendance_mark: 3, attendance_change: true)
                     .where(worked_on: Time.zone.now.beginning_of_month..Time.zone.now.end_of_month)
  end
  
  def ajax
    date = Date.new(params[:value_year].to_i, params[:value_month].to_i)
    @logs = Attendance.where(attendance_mark: 3, attendance_change: true)
                   .where(worked_on: date.beginning_of_month..date.end_of_month)
    logs = render_to_string(
        partial: 'table_time_log'
      )
     render json: {
            logs: logs,
            success: true # クライアント(js)側へsuccessを伝えるために付加
          }
  end
  
  private
    # 所属長承認申請
    def superior_notice_params
      params.permit(attendances: [:superior_mark, :superior_change])[:attendances]
    end
    # 勤怠変更申請
    def attendances_params
      params.permit(attendances: [:started_at_2, :finished_at_2, :attendance_next, :note, :superior_selection])[:attendances]
    end
    def attendance_notice_params
      params.permit(attendances: [:started_at, :finished_at, :started_at_2, :finished_at_2, :note, :attendance_mark, :attendance_change])[:attendances]
    end
    # 残業申請
    def overtime_notice_params
      params.permit(attendances: [:expected_end_time, :overtime_work, :superior_select, :next, :overtime_mark, :overtime_change])[:attendances]
    end
    
    def attendances_invalid?
      attendances = true
      attendances_params.each do |id,item|
        if item[:started_at_2].blank? && item[:finished_at_2].blank?
          next
        elsif item[:started_at_2].blank? || item[:finished_at_2].blank?
          attendances = false
          break
        elsif item[:attendance_next] == "1"
          item[:finished_at_2] = item[:finished_at_2]
          next
        elsif item[:started_at_2] > item[:finished_at_2]
          attendances = false
          break
        end
      end
      return attendances
    end
    
end
