class AddAttendanceNoticeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :superior_selection, :integer
    add_column :attendances, :attendance_mark, :integer
    add_column :attendances, :attendance_next, :boolean, default: false
    add_column :attendances, :superior_change, :boolean, default: false
  end
end
