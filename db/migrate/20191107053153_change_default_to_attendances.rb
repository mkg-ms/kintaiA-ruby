class ChangeDefaultToAttendances < ActiveRecord::Migration[5.1]
  def change
    change_column :attendances, :attendance_next, :boolean, default: false
    change_column :attendances, :attendance_change, :boolean, default: false
  end
end
