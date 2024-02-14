class MakeActivitiesPolymorphic < ActiveRecord::Migration[7.1]
  def up
    # Step 1: Add temporary column for character_id
    add_column :activities, :temp_character_id, :integer

    # Step 2: Copy character_id data to temp_character_id
    Activity.update_all("temp_character_id = character_id")

    # Step 3: Modify activities table for polymorphism
    remove_column :activities, :character_id
    add_reference :activities, :activityable, polymorphic: true, null: true

    # Step 4: Migrate data from temp_character_id to new polymorphic columns
    Activity.reset_column_information
    Activity.find_each do |activity|
      activity.update(activityable_type: "Character", activityable_id: activity.temp_character_id)
    end

    # Step 5: Remove the temporary column
    remove_column :activities, :temp_character_id
  end

  def down
    # Reverse the migration
    add_column :activities, :character_id, :integer
    # You'd also need to reverse the data migration here, if supporting down migration
    remove_reference :activities, :activityable, polymorphic: true
  end
end
