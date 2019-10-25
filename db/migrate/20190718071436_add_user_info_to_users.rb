class AddUserInfoToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :employee_number, :integer
    add_column :users, :uid, :string, unique: true
    add_column :users, :designated_work_start_time, :datetime, default: Time.zone.parse("2019/10/13 09:00")
    add_column :users, :designated_work_end_time, :datetime, default: Time.zone.parse("2019/10/13 18:00")
  end
end
