class CreateSettlements < ActiveRecord::Migration[7.1]
  def change
    create_table :settlements do |t|
      t.string :name
      t.string :location
      t.integer :level

      t.timestamps
    end
  end
end
