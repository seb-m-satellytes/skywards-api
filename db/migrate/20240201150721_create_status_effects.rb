class CreateStatusEffects < ActiveRecord::Migration[7.1]
  def change
    create_table :status_effects do |t|
      t.string :name
      t.integer :start_time
      t.integer :end_time
      t.references :character, null: false, foreign_key: true

      t.timestamps
    end
  end
end
