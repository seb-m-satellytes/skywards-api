class AddExperiencesTable < ActiveRecord::Migration[6.0]
  def change
    create_table :xp_points do |t|
      t.references :xpable, polymorphic: true, null: true
      t.integer :xp, default: 0, null: false
      t.timestamps
    end
  end
end
