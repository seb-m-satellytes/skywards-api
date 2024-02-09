class RemoveAvailableSlotsFromSettlement < ActiveRecord::Migration[7.1]
  def change
    remove_column :settlements, :available_slots, :integer
  end
end
