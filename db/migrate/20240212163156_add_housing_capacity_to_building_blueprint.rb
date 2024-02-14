class AddHousingCapacityToBuildingBlueprint < ActiveRecord::Migration[7.1]
  def change
    add_column :building_blueprints, :housing_capacity, :integer
  end
end
