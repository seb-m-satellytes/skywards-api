class AddUsabilitySlots < ActiveRecord::Migration[7.1]
  def change
    add_column :slots, :usable, :integer, default: 0
  end
end
