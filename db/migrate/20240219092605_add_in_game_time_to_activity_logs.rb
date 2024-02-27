class AddInGameTimeToActivityLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :activity_logs, :in_game_time, :integer
  end
end
