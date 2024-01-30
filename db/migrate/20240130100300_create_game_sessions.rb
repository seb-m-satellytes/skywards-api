class CreateGameSessions < ActiveRecord::Migration[7.1]
  def change
    create_table :game_sessions do |t|
      t.timestamp :start_time
      t.integer :in_game_minutes, default: 0

      t.timestamps
    end
  end
end
