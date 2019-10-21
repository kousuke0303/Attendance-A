module AttendancesHelper
  def attendance_state(attendance)
    if Date.current == attendance.worked_on
      return '出勤' if attendance.started_at.nil?
      return '退勤' if attendance.started_at.present? && attendance.finished_at.nil?
    end
    false
  end
  
  def working_times(day)
    if day.overnight == 1
      str_to_min = day.started_at.hour * 60 + day.started_at.min
      fin_to_min = day.finished_at.hour * 60 + day.finished_at.min
      format("%.2f", (1440 - str_to_min + fin_to_min) / 60.0)
    else
      format("%.2f", (((day.finished_at - day.started_at) / 60 ) / 60.0 ))
    end
  end
  
  # ユーザーに対する残業申請を配列と定義
  
  def applying_overtime_attendances
    Attendance.where(overtime_target_user_id: @user.id, overtime_status: "申請中").
      or(Attendance.where(overtime_target_user_id: @user.id, overtime_status: "否認"))
  end
  
  # 上記を申請ユーザー毎にグループ化
  
  def grouped_attendances
    applying_overtime_attendances.group_by(&:user_id)
  end
  
  # ユーザーに対する勤怠変更申請を配列と定義

  def applying_edited_attendances
    Attendance.where(edit_target_user_id: @user.id, edit_status: "申請中").
      or(Attendance.where(edit_target_user_id: @user.id, edit_status: "否認"))
  end
  
  def grouped_edited_attendances
    applying_edited_attendances.group_by(&:user_id)
  end
    
  def search_user(attendance)
    user = User.find(attendance.user_id)
  end
  
  def search_approve_user(attendance)
    user = User.find(attendance.edit_target_user_id)
  end
  
  def search_month_target_user(attendance)
    user = User.find(attendance.month_target_user_id)
  end
  
  def overtime_status(day)
    user = User.find(day.overtime_target_user_id)
    case day.overtime_status
    when "申請中"
      "#{user.name}へ残業申請中"
    when "承認"
      "#{user.name}より残業承認済"
    when "否認"
      "#{user.name}より残業否認"
    end
  end
  
  def edit_status(day)
    user = User.find(day.edit_target_user_id)
    case day.edit_status
    when "申請中"
      "#{user.name}へ勤怠変更申請中"
    when "承認"
      "#{user.name}より勤怠変更承認済"
    when "否認"
      "#{user.name}より勤怠変更否認"
    end
  end
  
  def approved_log(user)
    Attendance.where(user_id: user.id, edit_status: "承認")
  end
end
