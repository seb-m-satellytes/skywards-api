class CreateSlotsTable < ActiveRecord::Migration[7.1]
  def change
    create_table :slots do |t|
      t.references :settlement, null: false, foreign_key: true
      t.references :building, null: true, foreign_key: true

      t.timestamps
    end
  end
end
