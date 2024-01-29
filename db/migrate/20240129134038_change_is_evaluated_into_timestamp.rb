class ChangeIsEvaluatedIntoTimestamp < ActiveRecord::Migration[7.1]
  def change
    change_column :activities, :is_evaluated, :timestamp
  end
end
