class Attendance < ApplicationRecord
  belongs_to :user
  validates :worked_on, presence: true
  validate :started_at_must_exist
  validate :finished_at_cannot_be_faster_than_started_at

  def started_at_must_exist
    if started_at.blank? && finished_at.present?
      errors.add("出勤時間がありません")
    end
  end
  
  def finished_at_cannot_be_faster_than_started_at 
    if started_at.present? && finished_at.present? && started_at > finished_at
      errors.add("出勤時間よりも後の時刻を登録してください")
    end
  end
end