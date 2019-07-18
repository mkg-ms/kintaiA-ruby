class RenameOvertimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    rename_column :attendances, :ecpected_end_time, :expected_end_time
  end
end
