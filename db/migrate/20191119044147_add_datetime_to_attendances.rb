class AddDatetimeToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :started_at_2, :datetime
    add_column :attendances, :finished_at_2, :datetime
  end
end
