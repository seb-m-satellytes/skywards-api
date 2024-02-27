class RemoveForeignKeySettlementIdFromBuildings < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :buildings, column: :settlement_id
    remove_column :buildings, :settlement_id
  end
end
