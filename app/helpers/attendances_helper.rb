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
  
  # ユーザーに対する残業申請を配列と定義
  
  def applying_overtime_attendances
     Attendance.where(overtime_target_user_id: @user.id, overtime_status: "申請中").or(Attendance.where(overtime_target_user_id: @user.id, overtime_status: "否認"))
  end
  
  # 上記を申請ユーザー毎にグループ化
  
  def grouped_attendances
    Attendance.where(overtime_target_user_id: @user.id, overtime_status: "申請中").
      or(Attendance.where(overtime_target_user_id: @user.id, overtime_status: "否認")).group_by(&:user_id)
  end
  
  def search_user(attendance)
    user = User.find(attendance.user_id)
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
end
