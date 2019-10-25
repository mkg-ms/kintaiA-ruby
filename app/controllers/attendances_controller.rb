class AttendancesController < ApplicationController
  
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
  
  def edit
    @user = User.find(params[:id])
    @first_day = first_day(params[:date])
    @last_day = @first_day.end_of_month
    @dates = user_attendances_month_date
  end
  
  def update
    @user = User.find(params[:id])
    if attendances_invalid?
      attendances_params.each do |id,item|
        attendance = Attendance.find(id)
        attendance.update_attributes(item)
      end
      flash[:success] = "勤怠情報を更新しました。"
      redirect_to user_path(@user, params:{first_day: params[:date]})
    else
      flash[:danger] = "不正な時間入力がありました、再入力してください。"
      redirect_to edit_attendances_path(@user, params[:date])
    end
  end
  
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
    if attendances_overtime_params.each do |id,item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
       end
      flash[:success] = "勤怠情報を更新しました。"
      redirect_to user_path(@user)
    else
      flash[:danger] = "不正な時間入力がありました、再入力してください。"
      redirect_to edit_attendances_path(@user, params[:date])
    end
  end
  
  def edit_superior_notice
  end
  
  def update_superior_notice
  end
  
  def edit_attendance_notice
  end
  
  def update_attendance_notice
  end
  
  def edit_overtime_notice
    @user = User.find(params[:id])
    @day = Date.parse(params[:date])
    @attendance = @user.attendances.find_by(worked_on: params[:date])
  end
  
  def update_overtime_notice
  end
  
  private
  
    def attendances_params
      params.permit(attendances: [:started_at, :finished_at, :note, :expected_end_time])[:attendances]
    end
    
    def attendances_overtime_params
      params.permit(attendances: [:expected_end_time, :overtime_work, :superior_select])[:attendances]
    end
end

