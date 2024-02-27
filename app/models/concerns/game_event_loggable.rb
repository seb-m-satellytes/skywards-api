module GameEventLoggable
  extend ActiveSupport::Concern

  included do
    has_many :activity_logs, as: :loggable, dependent: :destroy

    def filtered_game_events_last_minutes
      last_minute = GameSession.first.in_game_minutes - 5
      activity_logs.where("in_game_time >= ?", last_minute)
    end
  end


  def log_event(description, loggable_object = self)
    current_time = GameSession.first.in_game_minutes
    if loggable_object.nil?
      self.activity_logs.create(description: description, in_game_time: current_time)
    else
      loggable_object.activity_logs.create(description: description, in_game_time: current_time)
    end
  end
end
