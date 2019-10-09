class Attendance < ApplicationRecord
  belongs_to :user
  
  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  validates :overtime_content, length: { in: 2..100 }, allow_blank: true
  
  # 出勤時間が存在しない場合、退勤時間は無効
  validate :finished_at_is_invalid_without_a_started_at
  # 出勤・退勤時間どちらも存在する時、出勤時間より早い退勤時間は無効
  validate :started_at_than_finished_at_fast_if_invalid
  # 残業申請欄必須項目
  validate :apply_overtime_required_item
  
  def finished_at_is_invalid_without_a_started_at
    errors.add(:started_at, "が必要です。") if started_at.blank? && finished_at.present?
  end
  
  def started_at_than_finished_at_fast_if_invalid
    if started_at.present? && finished_at.present?
      errors.add(:started_at, "より早い退勤時間は無効です") if started_at > finished_at
    end
  end
  
  def apply_overtime_required_item
    if plans_end_work_time.present? || overtime_content.present? ||
      overtime_tomorrow_check.present? || overtime_target_user_id.present?
      unless plans_end_work_time.present? && overtime_content.present? && overtime_target_user_id.present?
        errors.add(:plans_end_work_time, "、業務処理内容、申請先上長の選択が必要です")
      end
    end
  end
end
