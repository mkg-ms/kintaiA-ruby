class RenameSuperiorChangeColumnToAttendances < ActiveRecord::Migration[5.1]
  def change
    rename_column :attendances, :superior_change, :attendance_change
  end
end
