class AddSuperiorSelectorToAttendances < ActiveRecord::Migration[5.1]
  def change
    add_column :attendances, :superior_selector, :integer
  end
end
