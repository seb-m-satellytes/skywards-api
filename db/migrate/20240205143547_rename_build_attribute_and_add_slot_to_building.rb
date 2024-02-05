class RenameBuildAttributeAndAddSlotToBuilding < ActiveRecord::Migration[7.1]
  def change
    rename_column :buildings, :build_at, :built_at
    add_column :buildings, :slot, :integer, default: 0 
  end
end
