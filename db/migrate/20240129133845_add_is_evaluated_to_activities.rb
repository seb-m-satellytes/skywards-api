class AddIsEvaluatedToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :is_evaluated, :boolean
  end
end
