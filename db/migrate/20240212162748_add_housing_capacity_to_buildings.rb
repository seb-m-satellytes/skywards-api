class AddHousingCapacityToBuildings < ActiveRecord::Migration[7.1]
  def change
    add_column :buildings, :housing_capacity, :integer
  end
end
