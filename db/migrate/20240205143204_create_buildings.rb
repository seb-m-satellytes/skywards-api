class CreateBuildings < ActiveRecord::Migration[7.1]
  def change
    create_table :buildings do |t|
      t.string :name
      t.references :settlement, null: false, foreign_key: true
      t.string :building_type
      t.integer :build_at

      t.timestamps
    end
  end
end
