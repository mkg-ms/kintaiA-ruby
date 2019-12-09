class Attendance < ApplicationRecord
  belongs_to :user
  validates :worked_on, presence: true
  validate :must_choice_superior, on: :update
　
　# 勤怠編集にて指示者を確認しなければいけない。
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
