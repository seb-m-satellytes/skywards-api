class GameSession < ApplicationRecord
  has_many :settlements

  def current_day
    in_game_minutes / 1440
  end

  def current_time
    remaining_minutes = in_game_minutes % 1440

    hour = remaining_minutes / 60
    minute = remaining_minutes % 60
    
    return format('%02d:%02d', hour, minute)
  end
end
