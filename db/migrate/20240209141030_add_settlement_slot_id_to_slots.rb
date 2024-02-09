class AddSettlementSlotIdToSlots < ActiveRecord::Migration[7.1]
  def change
    add_column :slots, :settlement_slot_id, :integer
  end
end
