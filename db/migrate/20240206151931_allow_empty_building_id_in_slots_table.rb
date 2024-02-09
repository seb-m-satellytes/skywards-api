class AllowEmptyBuildingIdInSlotsTable < ActiveRecord::Migration[7.1]
  def change
    change_column_null :slots, :building_id, true
  end
end
