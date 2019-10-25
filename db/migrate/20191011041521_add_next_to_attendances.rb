class AddNextToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :next, :boolean, default: false
  end
end
