class AddOvertimeNoticeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :overtime_mark, :integer
    add_column :attendances, :overtime_change, :boolean, default: false
  end
end
