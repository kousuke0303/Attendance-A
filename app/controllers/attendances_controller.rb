class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :admin_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
  before_action :set_one_month, only: :edit_one_month
  
  UPDATE_ERROR_MSG = "勤怠登録に失敗しました。やり直してください。"
  
  def update
    @user = User.find(params[:user_id])
    @attendance = Attendance.find(params[:id])
    if @attendance.started_at.nil?
      if @attendance.update_attributes(started_at: Time.current.change(sec: 0))
        flash[:info] = "おはようございます！"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    elsif @attendance.finished_at.nil?
      if @attendance.update_attributes(finished_at: Time.current.change(sec: 0))
        flash[:info] = "お疲れ様でした。"
      else
        flash[:danger] = UPDATE_ERROR_MSG
      end
    end
    redirect_to @user
  end
  
  def edit_one_month
  end
  
  def update_one_month
    ActiveRecord::Base.transaction do
      attendances_params.each do |id, item|
        attendance = Attendance.find(id)
        attendance.update_attributes!(item)
        unless attendance.worked_on == Date.current
          if attendance.started_at.present? && attendance.finished_at.blank?
            raise ActiveRecord::RecordInvalid
          end
        end
      end
    end
    flash[:success] = "1ヶ月分の勤怠情報を更新しました。"
    redirect_to user_url(date: params[:date])
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "無効な入力データがあった為、更新をキャンセルしました。"
    redirect_to attendances_edit_one_month_user_url(date: params[:date])
  end
  
  def apply_overtime
    attendances = Attendance.where(worked_on: params[:hidden_date], user_id: current_user.id)
    attendance = attendances[0]
    if attendance.update_attributes(plans_end_work_time: params[:plans_end_work_time],
                                    overtime_tomorrow_check: params[:overtime_tomorrow_check],
                                    overtime_content: params[:overtime_content],
                                    overtime_target_user_id: params[:overtime_target_user_id])
      attendance.update_attributes(overtime_status: "applying")
      target_user = User.find(params[:overtime_target_user_id])
      flash[:success] = "#{target_user.name}へ残業を申請しました。"
      redirect_to user_url(current_user)
    else
      flash[:danger] = "終了予定時間、業務処理内容(2~100文字)、申請先上長を入力してください。"
      redirect_to user_url(current_user)
    end
  end
  
  private
  
    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
    end
end
