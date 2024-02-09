class Building < ApplicationRecord
  has_many :slot
  has_one :settlement, through: :slot
  
  def is_finished(built_at, in_game_minutes)
    in_game_minutes - built_at > 0
  end
end
