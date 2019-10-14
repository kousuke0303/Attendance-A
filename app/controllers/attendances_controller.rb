class AttendancesController < ApplicationController
  before_action :set_user, only: [:edit_one_month, :update_one_month, :approve_overtime]
  before_action :logged_in_user, only: [:update, :edit_one_month]
  before_action :superior_or_correct_user, only: [:update, :edit_one_month, :update_one_month]
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
      user = User.find(attendance.user_id)
      d_w_e_t_to_min = user.designated_work_end_time.hour * 60 + user.designated_work_end_time.min
      if attendance.overtime_tomorrow_check == 0
        overtime = format("%.2f", (attendance.plans_end_work_time.hour * 60 + attendance.plans_end_work_time.min - d_w_e_t_to_min) / 60.0)
      elsif attendance.overtime_tomorrow_check == 1
        overtime = format("%.2f", (1440 - d_w_e_t_to_min + attendance.plans_end_work_time.hour * 60 + attendance.plans_end_work_time.min) / 60.0)
      end
      attendance.update_attributes(overtime: overtime, overtime_status: "申請中")
      target_user = User.find(params[:overtime_target_user_id])
      flash[:success] = "#{target_user.name}へ残業を申請しました。"
      redirect_to user_url(current_user)
    else
      flash[:danger] = "終了予定時間、業務処理内容(2~100文字)、申請先上長を入力してください。"
      redirect_to user_url(current_user)
    end
  end
  
  def approve_overtime
    ActiveRecord::Base.transaction do
      before_count = Attendance.where(overtime_target_user_id: @user.id, overtime_status: "申請中").count
      params[:attendances].each do |id, item|
        attendance = Attendance.find(id)
        if item["overtime_tomorrow_check"] == "1"
          unless attendance.update_attributes!(overtime_status: item["overtime_status"])
            raise ActiveRecord::RecordInvalid
          end
        end
      end
      after_count = before_count - Attendance.where(overtime_target_user_id: @user.id, overtime_status: "申請中").count
      flash[:success] = "#{after_count}件の残業申請情報を更新しました。"
      redirect_to user_url(date: params[:date])
    end
  rescue ActiveRecord::RecordInvalid
    flash[:danger] = "無効な入力データがあった為、入力をキャンセルしました。"
    redirect_to user_url(date: params[:date])
  end
  
  private
  
    # 1ヶ月分の勤怠情報を扱います。
    def attendances_params
      params.require(:user).permit(attendances: [:started_at, :finished_at, :note])[:attendances]
    end
end
