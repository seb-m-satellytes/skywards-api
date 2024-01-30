class AddGameSessionRefToSettlements < ActiveRecord::Migration[7.1]
  def change
    add_reference :settlements, :game_session, null: true, foreign_key: true
  end
end
