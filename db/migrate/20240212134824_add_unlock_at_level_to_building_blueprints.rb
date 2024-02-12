class AddUnlockAtLevelToBuildingBlueprints < ActiveRecord::Migration[7.1]
  def change
    add_column :building_blueprints, :unlock_at_settlement_level, :integer, default: 1
  end
end
