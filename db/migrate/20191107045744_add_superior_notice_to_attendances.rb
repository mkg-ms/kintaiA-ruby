class AddSuperiorNoticeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :superior_mark, :integer
    add_column :attendances, :superior_change, :boolean, default: false
  end
end
