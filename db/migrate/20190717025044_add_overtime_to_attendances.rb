class AddOvertimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :ecpected_end_time, :datetime, default: Time.zone.parse
  end
end
