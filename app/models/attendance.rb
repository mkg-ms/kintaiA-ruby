class Attendance < ApplicationRecord
  belongs_to :user
  validates :worked_on, presence: true
  validate :finished_at, presence: true
  validate :finished_at, presence: true
end
