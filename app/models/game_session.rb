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

  def tick
    self.in_game_minutes += 1
    self.save!
  end

  def do_events
    if self.current_time == '06:00'
      #Settlement.first.all_eat('breakfast')
    end

    if self.current_time == '12:00'
      #Settlement.first.all_eat('lunch')
    end

    if self.current_time == '18:00'
      #Settlement.first.all_eat('dinner')
    end

    settlement = Settlement.first

    # check if any buildings with the status under_construction are done
    settlement.buildings.each do |building|
      if building.status == 'under_construction' && building.built_at <= self.in_game_minutes
        building.update!(status: "usable")
      end
    end

    settlement.activities.each do |activity|
      if activity.activity_type == 'hire' && activity.end_time == 0
        elapsed_minutes = self.in_game_minutes - activity.start_time
        probability = (elapsed_minutes.to_f / 1440) * 100
        logger.info("Probability: #{probability}")
        if rand(100) < probability
          activity.end_time = self.in_game_minutes
          activity.save!
        end
      end
    end

  end
end
