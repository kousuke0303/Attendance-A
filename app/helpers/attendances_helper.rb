module AttendancesHelper
  def attendance_state(attendance)
    if Date.current == attendance.worked_on
      return '出勤' if attendance.started_at.nil?
      return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    false
  end
  
  def working_times(start, finish)
    format("%.2f", (((finish - start) / 60 ) / 60.0 ))
  end
  
  # 時間外時間を計算
  
  def overtime(day)
    d_w_e_t_to_min = @user.designated_work_end_time.hour * 60 + @user.designated_work_end_time.min
    if day.overtime_tomorrow_check == 0
      format("%.2f", (day.plans_end_work_time.hour * 60 + day.plans_end_work_time.min - d_w_e_t_to_min) / 60.0)
    elsif day.overtime_tomorrow_check == 1
      format("%.2f", (1440 - d_w_e_t_to_min + day.plans_end_work_time.hour * 60 + day.plans_end_work_time.min) / 60.0)
    end
  end
  
  # ユーザーに対する残業申請を配列と定義
  
  def applying_overtime_any?
    Attendance.where(overtime_target_user_id: @user.id, overtime_status: "applying")
  end
end
