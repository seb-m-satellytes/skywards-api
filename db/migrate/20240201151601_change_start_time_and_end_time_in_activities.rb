class ChangeStartTimeAndEndTimeInActivities < ActiveRecord::Migration[7.1]
  def change
    change_column :activities, :start_time, :integer, default: 0
    change_column :activities, :end_time, :integer, default: 0
  end
end
