class CreateBuildingBlueprints < ActiveRecord::Migration[7.1]
  def change
    create_table :building_blueprints do |t|
      t.string :name
      t.string :category
      t.text :base_resources
      t.text :necessary_workers
      t.integer :build_time
      t.integer :slots_required

      t.timestamps
    end
  end
end
