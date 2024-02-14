class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.string :activity_type
      t.timestamp :start_time
      t.timestamp :end_time
      t.integer :character_id

      t.timestamps
    end
  end
end
