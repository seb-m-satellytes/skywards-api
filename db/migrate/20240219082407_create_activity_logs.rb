class CreateActivityLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :activity_logs do |t|
      t.text :description
      t.references :loggable, polymorphic: true

      t.timestamps
    end
  end
end
