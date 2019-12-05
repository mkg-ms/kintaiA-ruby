class Attendance < ApplicationRecord
  belongs_to :user
  validates :worked_on, presence: true
  validate :started_at_must_exist
  validate :finished_at_cannot_be_faster_than_started_at
  validate :must_choice_superior, on: :update

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
  
  def must_choice_superior
    if started_at_2.present? && finished_at_2.present? && started_at_2 < finished_at_2 && superior_selection.nil?
      errors.add(:superior_selection, "を選択して下さい。")
    end
  end
  
  # 当時の日付を持ち、かつ出勤時間のみに値が存在する状態のユーザーを取得する。
  scope :worker, -> {
    where(attendances: {worked_on: Date.current, finished_at: nil}).
    where.not(attendances: {started_at: nil})
  }

end
