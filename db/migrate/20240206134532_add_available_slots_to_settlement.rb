class AddAvailableSlotsToSettlement < ActiveRecord::Migration[7.1]
  def change
    add_column :settlements, :available_slots, :integer
    add_column :buildings, :status, :string
  end
end
