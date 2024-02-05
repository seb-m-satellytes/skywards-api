class AddTargetToActivity < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :activity_target, :string
  end
end
