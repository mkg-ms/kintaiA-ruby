class User < ApplicationRecord

  has_many :attendances, dependent: :destroy    
  before_save {self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 100 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: {case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  validates :affiliation, length: { in: 3..50 }, allow_blank: true
  
  def self.import(file)
    CSV.foreach(file.path, headers: true, encoding: 'Shift_JIS:UTF-8') do |row|
      user = find_by(id: row["id"]) || new
      user.attributes = row.to_hash.slice(*updatable_attributes)
      unless user.save
        return false
      end
    end
    return true
  end

  # 更新を許可するカラムを定義
  def self.updatable_attributes
    ["id", "name", "email", "affiliation"]
  end
  
  # 所属長承認申請モーダルのお知らせのeach
  def self.application_manager_approval(superior: user)
    joins(:attendances).where.not(attendances: {superior_selector: nil, user_id: superior.id}).distinct
  end
  
  # 勤怠変更モーダルのお知らせのeach
  def self.attendance_change(superior: user)
    joins(:attendances).where.not(attendances: {started_at: nil, finished_at: nil, user_id: superior.id}).distinct
  end
  
  # 残業申請モーダルのお知らせのeach
  def self.overtime_applied_users(superior: user)
    joins(:attendances).where.not(attendances: {expected_end_time: nil, user_id: superior.id, overtime_change: true}).distinct
  end

end
