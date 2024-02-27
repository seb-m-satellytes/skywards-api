class Character < ApplicationRecord
  belongs_to :settlement
  has_many :resources, as: :resourceable
  has_many :activities, as: :activityable, dependent: :destroy
  has_many :status_effects, dependent: :destroy
  
  include GameEventLoggable

  def can_go_on_activity
    return false if health_status <= 30
    return false if self.status_effects.any? { |effect| effect.name == 'injured' }
    return true if activities.empty?

    activities.none? { |activity| activity.end_time.nil? || activity.is_evaluated.nil? }
  end

  def consume_meal(ration_buffer_days, mealname)
    food, water = meal_plan(ration_buffer_days, mealname)
    
    log_event("#{self.name} ate #{mealname} with #{food} food and #{water} water.")
    
    adjust_health_and_morale(ration_buffer_days, mealname, food, water)
    return food, water
  end

  def heal(end_time = nil)
    log_event("#{self.name} was healed.")
    
    self.status_effects.where(name: 'injured').each do |effect|
      effect.end_time = end_time
      effect.save!
    end
  end

  def current_activity
    activities.where(is_evaluated: nil).first
  end

  def current_status_effect
    current_time = GameSession.first.in_game_minutes
    ongoing_effects = status_effects.where("end_time >= ?", current_time)
    indefinite_effects = status_effects.where(end_time: nil)

    combined_effects = ongoing_effects.or(indefinite_effects)

    combined_effects.first
  end

  def heal_others(injured_characters)
    # Logic for healing others
    # You might want to loop through all characters in the settlement and heal them
    # You might want to apply a status effect to the character to prevent them from being healed again for a certain period of time
    # You might want to have a chance of success or failure
    # You might want to have the character's healing skill affect the outcome
    # You might want to have the character's health and morale affect the outcome
    # You might want to have the character's health and morale affected by the outcome
  end

  private

  def meal_plan(ration_buffer_days, mealname)
    # Define meal plans as a hash or another configurable structure
    # water, food
    w = 1
    f = 1

    meal_plans = {
      6 => { breakfast: [w, f], lunch: [w, f], dinner: [w, f] },
      5 => { breakfast: [w, 0], lunch: [w, f], dinner: [w, f] },
      4 => { breakfast: [w, 0], lunch: [w, 0], dinner: [w, f] },
      3 => { breakfast: [0, 0], lunch: [w, 0], dinner: [w, f] },
      2 => { breakfast: [0, 0], lunch: [0, 0], dinner: [w, f] },
      1 => { breakfast: [0, 0], lunch: [0, 0], dinner: [w, 0] },
    }

    meal_sym = mealname.to_sym
    # Default to no food and no water
    meal_plans[ration_buffer_days].fetch(meal_sym, [0, 0])
  end

  def health_and_morale_changes(ration_buffer_days, mealname, food, water)
    # Define the health and morale changes as a hash or another configurable structure

    #TODO: can we leverage food and water here instead of meal plan?

    # health, morale
    h = 4
    m = 3

    changes = {
        6 => { breakfast: [h, m], lunch: [h, m], dinner: [h, m] }, # h + / m +
        5 => { breakfast: [h, 0], lunch: [h, 0], dinner: [h, 0] }, # h + / m 0
        4 => { breakfast: [0, 0], lunch: [0, 0], dinner: [0, 0] }, # h 0 / m 0
        3 => { breakfast: [0, -m], lunch: [0, -m], dinner: [0, -m] }, # h 0 / m -
        2 => { breakfast: [-h, -m], lunch: [-h, -m], dinner: [-h, -m] }, # h - / m -
        1 => { breakfast: [-h, -m], lunch: [-h, -m], dinner: [-h, -m] }, # h -- / m --
    }

    meal_sym = mealname.to_sym

    day_changes = changes.fetch(ration_buffer_days, {})
    meal_changes = day_changes.fetch(meal_sym, [0, 0])
    return meal_changes
  end

  def adjust_health_and_morale(ration_buffer_days, mealname, food, water)
    health_change, morale_change = health_and_morale_changes(ration_buffer_days, mealname, food, water)

    log_event("#{self.name} lost #{health_change.abs} health.") if health_change < 0
    log_event("#{self.name} lost #{morale_change.abs} morale.") if morale_change < 0
    log_event("#{self.name} gained #{health_change.abs} health.") if health_change > 0
    log_event("#{self.name} gained #{morale_change.abs} morale.") if morale_change > 0
      
    if (self.status_effects.any? { |effect| effect.name == 'injured' })
      # If injured, health cannot go up
      new_health_status = self.health_status
    else
      new_health_status = (self.health_status + health_change).clamp(0, 100)
    end

    new_morale_status = (self.morale_status + morale_change).clamp(0, 100)

    self.update(health_status: new_health_status || 0, morale_status: new_morale_status || 0)

    check_status
  end
  
  private

  def check_status
    leave if self.morale_status < 10
    die if self.health_status == 0
  end

  def leave
    # Logic for character leaving
    log_event("#{self.name} has left the settlement due to low morale.")
    
    # Depending on your model, you might want to set a status or delete the character
    self.settlement = Settlement.find_by(name: 'Outside')

    self.save!
  end

  def die
    # Logic for character death
    log_event("#{self.name} has died.")
    
    self.status_effects.create(
      name: 'dead',
      start_time: GameSession.first.in_game_minutes,
      end_time: GameSession.first.in_game_minutes
    )  
  end
end
