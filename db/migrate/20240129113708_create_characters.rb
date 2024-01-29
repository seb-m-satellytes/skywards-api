class CreateCharacters < ActiveRecord::Migration[7.1]
  def change
    create_table :characters do |t|
      t.string :name
      t.integer :age
      t.integer :health_status
      t.integer :skill_level
      t.string :current_activity

      t.timestamps
    end
  end
end
